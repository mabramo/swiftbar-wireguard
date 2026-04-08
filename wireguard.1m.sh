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

# Locate wg-quick — SwiftBar runs with a limited PATH so we search common locations
WG_QUICK="$(PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:$PATH" command -v wg-quick 2>/dev/null)"

# ── State ──────────────────────────────────────────────────────────────────────
is_connected() {
  ifconfig "$WG_IFACE" &>/dev/null 2>&1
}

get_ip() {
  ifconfig "$WG_IFACE" 2>/dev/null | awk '/inet /{print $2}'
}

# ── Actions ────────────────────────────────────────────────────────────────────
if [ "${1:-}" = "up" ]; then
  [ -z "$WG_QUICK" ] && exit 1
  osascript -e 'do shell script "'"${WG_QUICK}"' up '"${WG_CONF}"'" with administrator privileges'
  exit 0
fi

if [ "${1:-}" = "down" ]; then
  [ -z "$WG_QUICK" ] && exit 1
  osascript -e 'do shell script "'"${WG_QUICK}"' down '"${WG_CONF}"'" with administrator privileges'
  exit 0
fi

# ── Menu bar display ───────────────────────────────────────────────────────────
if [ -z "$WG_QUICK" ]; then
  echo "VPN | color=red sfimage=lock.slash"
  echo "---"
  echo "wg-quick not found | color=red"
  echo "Install: brew install wireguard-tools wireguard-go | color=gray size=11"
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
