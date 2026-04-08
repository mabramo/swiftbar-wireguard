# WireGuard SwiftBar Plugin

A macOS menu bar WireGuard toggle — no App Store required.

![Connected](https://img.shields.io/badge/status-connected-green) ![License](https://img.shields.io/badge/license-MIT-blue)

## Features

- Shows VPN connected/disconnected status in the menu bar
- Click to connect or disconnect
- Displays your WireGuard IP when connected
- Uses SF Symbols (lock icon)
- No App Store, no subscriptions

## Requirements

- [SwiftBar](https://github.com/swiftbar/SwiftBar) (`brew install --cask swiftbar`)
- [wireguard-tools](https://formulae.brew.sh/formula/wireguard-tools) (`brew install wireguard-tools`)
- [wireguard-go](https://formulae.brew.sh/formula/wireguard-go) (`brew install wireguard-go`)
- [bash](https://formulae.brew.sh/formula/bash) (`brew install bash`) — macOS ships bash 3; `wg-quick` requires bash 4+

```bash
brew install --cask swiftbar
brew install wireguard-tools wireguard-go bash
```

## Installation

1. Install the requirements above
2. Copy `wireguard.1m.sh` to your SwiftBar plugins directory
3. Make it executable:
   ```bash
   chmod +x wireguard.1m.sh
   ```
4. Edit the config section at the top of the script:
   ```bash
   WG_CONF="${HOME}/.config/wireguard/wg0.conf"  # path to your config
   WG_IFACE="wg0"                                 # interface name
   ```
5. Refresh SwiftBar

## Usage

- **Menu bar icon:** lock (gray = disconnected, green = connected)
- **Click → Connect** to bring the tunnel up (will prompt for your password)
- **Click → Disconnect** to bring it down

## Config

The plugin reads `WG_CONF` and `WG_IFACE` from the top of the script. Edit these to match your setup. The interface name should match the filename of your WireGuard config without the `.conf` extension.

## License

MIT
