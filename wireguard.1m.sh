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

# Full path to wg-quick (SwiftBar runs with limited PATH)
WG_QUICK="$(command -v wg-quick 2>/dev/null || echo /opt/homebrew/bin/wg-quick)"

# ── State ──────────────────────────────────────────────────────────────────────
is_connected() {
  ifconfig "$WG_IFACE" &>/dev/null 2>&1
}

get_ip() {
  ifconfig "$WG_IFACE" 2>/dev/null | awk '/inet /{print $2}'
}

# ── Actions ────────────────────────────────────────────────────────────────────
if [ "${1:-}" = "up" ]; then
  osascript -e 'do shell script "'"${WG_QUICK}"' up '"${WG_CONF}"'" with administrator privileges'
  exit 0
fi

if [ "${1:-}" = "down" ]; then
  osascript -e 'do shell script "'"${WG_QUICK}"' down '"${WG_CONF}"'" with administrator privileges'
  exit 0
fi

# ── Menu bar display ───────────────────────────────────────────────────────────
if is_connected; then
  IP=$(get_ip)
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
