# WireGuard SwiftBar Plugin

A macOS menu bar WireGuard toggle — no App Store required.

![License](https://img.shields.io/badge/license-MIT-blue)

## Features

- Shows VPN connected/disconnected status in the menu bar
- Click to connect or disconnect
- Displays your WireGuard IP when connected
- Uses SF Symbols (lock icon)
- No App Store, no subscriptions, no accounts

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
4. Edit the config at the top of the script to point to your WireGuard config file:
   ```bash
   WG_CONF="${HOME}/.config/wireguard/wg0.conf"
   ```
5. Refresh SwiftBar

## Usage

- **Menu bar icon:** lock open (gray = disconnected), lock filled (green = connected)
- **Connect** — brings the tunnel up, prompts for your password once
- **Disconnect** — brings it down
- The icon updates automatically after the tunnel state changes (polls up to 15s)

## DNS

`wg-quick` sets system-wide DNS when a `DNS =` line is present in your config, which breaks internet connectivity if your DNS server is only reachable over the tunnel.

For split DNS — routing only `.lan` (or your local domain) queries to your internal DNS while leaving everything else alone — use macOS's built-in per-domain resolver:

```bash
sudo mkdir -p /etc/resolver
echo "nameserver <your-dns-ip>" | sudo tee /etc/resolver/lan
```

Then omit the `DNS =` line from your `wg0.conf`. macOS will send `.lan` queries to your internal DNS and use your normal DNS for everything else.

## Notes

- On macOS, `wireguard-go` creates a `utun` interface (e.g. `utun4`) rather than a named `wg0` interface. The plugin handles this automatically.
- `wg-quick` and `wg` are not on SwiftBar's default `PATH`. The plugin locates them via `find` on known Homebrew paths rather than relying on `PATH`.
- The plugin will display a warning in the menu bar if `wg-quick` or `bash 4+` are not found.

## License

MIT
