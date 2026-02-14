# EDGE

macOS desktop — 2018 MacBook Pro 15", Intel Core i9

## Hardware

| Component | Model                          |
| --------- | ------------------------------ |
| Machine   | MacBook Pro 15-inch, 2018      |
| CPU       | 2.9 GHz 6-Core Intel Core i9   |
| GPU       | Radeon Pro Vega 20 4 GB        |
| iGPU      | Intel UHD Graphics 630 1536 MB |
| RAM       | 32 GB 2400 MHz DDR4            |
| Storage   | Apple SSD AP1024M, 1 TB        |

## Configuration overview

- **OS:** macOS (nix-darwin), x86_64-darwin, stable channel
- **Nix Daemon:** Managed by Determinate installer (`nix.enable = false`)
- **Shell:** Bash (with completions), Starship prompt (pastel-powerline)
- **Networking:** WakeOnLAN, hostname/computerName/localHostName/SMB
- **Environment:** `LANG=en_GB.UTF-8`, timeZone `Europe/Amsterdam`
- **System Preferences:** Control Center, Dock, Finder, Trackpad, Power, Security (all managed)
- **Fonts:** Nerd Fonts, Google Fonts
- **System Packages:** git, gh, nano
- **Garbage Collection:** Disabled — Determinate Nix manages its own GC
- **Dev Tools:** Git, fnm (Node), pyenv (Python), Android tools, Ansible
- **CLI:** Fastfetch, SSH, shell aliases
- **macOS:** Rectangle (window management)

## Installed applications

### Homebrew brews

| Formula | Description          |
| ------- | -------------------- |
| mpv     | CLI/GUI media player |

### Homebrew casks

**Window management**

- rectangle

**Browsers & Communication**

- brave-browser
- discord
- librewolf
- signal

**Media**

- handbrake-app
- moonlight
- shotcut
- spotify
- steam
- vlc

**Productivity**

- beeper
- ferdium
- nextcloud
- orbstack
- syncthing-app

**Email**

- thunderbird

**Security & VPN**

- mullvad-vpn
- proton-mail-bridge

**Development**

- visual-studio-code

**System & Hardware**

- appcleaner
- insync
- libreoffice
- localsend
- raspberry-pi-imager
- sweet-home3d
- the-unarchiver
- unraid-usb-creator-next
- yubico-authenticator

### Mac App Store

| App       | ID         |
| --------- | ---------- |
| WireGuard | 1451685025 |

## Useful commands

```bash
# Rebuild and switch
darwin-rebuild switch --flake .#EDGE

# Or use the shell alias from anywhere
switch
```

## Hardware diagnostics

```bash
# System info
system_profiler SPHardwareDataType

# Memory
system_profiler SPMemoryDataType

# Storage
system_profiler SPStorageDataType
```
