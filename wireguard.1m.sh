#!/usr/bin/env bash
# <swiftbar.title>WireGuard</swiftbar.title>
# <swiftbar.version>1.0.0</swiftbar.version>
# <swiftbar.author>Michael Abramo</swiftbar.author>
# <swiftbar.author.github>mabramo</swiftbar.author.github>
# <swiftbar.desc>Toggle WireGuard tunnel from the menu bar. No App Store required.</swiftbar.desc>
# <swiftbar.dependencies>wireguard-tools,wireguard-go</swiftbar.dependencies>
# <swiftbar.abouturl>https://github.com/mabramo/swiftbar-wireguard</swiftbar.abouturl>

# ── Config ─────────────────────────────────────────────────────────────────────
# Path to your WireGuard config file
WG_CONF="${HOME}/.config/wireguard/wg0.conf"

# Interface name — must match the filename without extension
WG_IFACE="wg0"

# Locate wg-quick and bash 4+ — SwiftBar runs with a limited PATH so we search common locations
WG_QUICK="$(find /opt/homebrew/bin /usr/local/bin /usr/bin -name wg-quick 2>/dev/null | head -1)"
BASH4="$(find /opt/homebrew/bin /usr/local/bin -name bash 2>/dev/null | head -1)"

# ── State ──────────────────────────────────────────────────────────────────────
# On macOS, wireguard-go uses a utun interface — find it by checking all utun
# interfaces for an address in the WireGuard subnet (10.0.0.0/24)
wg_utun() {
  ifconfig 2>/dev/null | awk '/^utun/{iface=$1} /inet 10\.0\.0\./{print iface; exit}'
}

is_connected() {
  [ -n "$(wg_utun)" ]
}

get_ip() {
  local iface
  iface=$(wg_utun)
  ifconfig "$iface" 2>/dev/null | awk '/inet /{print $2}'
}

# ── Actions ────────────────────────────────────────────────────────────────────
swiftbar_refresh() {
  open "swiftbar://refreshPlugin?name=$(basename "$0")"
}

if [ "${1:-}" = "up" ]; then
  [ -z "$WG_QUICK" ] && exit 1
  osascript -e 'do shell script "'"${BASH4}"' '"${WG_QUICK}"' up '"${WG_CONF}"' > /tmp/wg-swiftbar.log 2>&1" with administrator privileges'
  # Wait for interface to come up before refreshing (up to 15s)
  for _ in $(seq 1 15); do
    is_connected && break
    sleep 1
  done
  swiftbar_refresh
  exit 0
fi

if [ "${1:-}" = "down" ]; then
  [ -z "$WG_QUICK" ] && exit 1
  osascript -e 'do shell script "'"${BASH4}"' '"${WG_QUICK}"' down '"${WG_CONF}"' > /tmp/wg-swiftbar.log 2>&1" with administrator privileges'
  # Wait for interface to go down before refreshing (up to 15s)
  for _ in $(seq 1 15); do
    is_connected || break
    sleep 1
  done
  swiftbar_refresh
  exit 0
fi

# ── Menu bar display ───────────────────────────────────────────────────────────
if [ -z "$WG_QUICK" ] || [ -z "$BASH4" ]; then
  echo "VPN | color=red sfimage=lock.slash"
  echo "---"
  [ -z "$WG_QUICK" ] && echo "wg-quick not found | color=red"
  [ -z "$BASH4" ]    && echo "bash 4+ not found | color=red"
  echo "Install: brew install wireguard-tools wireguard-go bash | color=gray size=11"
  exit 0
fi

if is_connected; then
  echo "VPN | color=green sfimage=lock.fill"
else
  echo "VPN | color=gray sfimage=lock.open"
fi

echo "---"

if is_connected; then
  IP=$(get_ip)
  echo "Connected — ${IP} | color=green"
  echo "Disconnect | bash='$0' param1=down terminal=false refresh=true"
else
  echo "Disconnected | color=gray"
  echo "Connect | bash='$0' param1=up terminal=false refresh=true"
fi

echo "---"
echo "Config: ${WG_CONF} | size=11 color=gray"
