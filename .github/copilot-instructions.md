# Nix Configuration — Copilot Instructions

## Project Structure

- `flake.nix` + `flake/` — Flake entry, builders for darwinConfigurations, nixosConfigurations, homeConfigurations
- `hosts/<HOSTNAME>/` — Per-host config: `user-settings.nix`, `configuration/`, `home-manager/`
- `modules/home-manager/` — Shared home-manager modules (`all/`, `darwin/`, `linux/`)
- `modules/systems/` — System-level modules (`darwin/`, `nixos/`, `shared/`)
- `scripts/nixos/install.sh` and `scripts/nixos/postinstall.sh` are the source of truth for the NixOS install and post-install workflows. `scripts/nixos/INSTALL.md` documents the same steps and must stay aligned with both scripts.

## Custom Module Convention

All modules use a `custom.*.enable` toggle pattern:

```nix
{
  options.custom.<name>.enable = lib.mkEnableOption "description";
  config = lib.mkIf config.custom.<name>.enable { ... };
}
```

Modules are imported in the host's `home-manager/default.nix` or `configuration/default.nix`, then explicitly enabled with `custom.<name>.enable = true`.

New modules should include a comment header with: one-line purpose, brief explanation, and a `Usage:` block showing the import path and enable flag.

When a module option could be derived from existing NixOS config (e.g., swap UUID from `swapDevices`, hostname from `networking.hostName`), make the option optional with a `null` default and auto-derive. Add an assertion for clear errors when auto-derivation fails and no explicit value is provided.

## Module Placement

- `modules/home-manager/all/` — Cross-platform modules usable on both NixOS and darwin (e.g., `git.nix`, `brave.nix`, `mpv.nix`)
- `modules/home-manager/linux/` — Linux-only modules: KDE/Plasma config, Linux GUI apps, desktop entries (e.g., `vesktop.nix`, `gaming.nix`, `plasma-config.nix`)
- `modules/home-manager/darwin/` — macOS-only modules (e.g., `rectangle.nix`)
- `modules/systems/nixos/` — NixOS system-level modules
- `modules/systems/darwin/` — nix-darwin system-level modules
- `modules/systems/shared/` — System modules shared between NixOS and darwin

When an app is cross-platform in nixpkgs but only used on Linux hosts in this repo (e.g., Discord/Vesktop — macOS uses Homebrew cask), place it in `linux/`.

## Host Wiring

- `default.nix` is the import entry point for both `configuration/` and `home-manager/`
- `user-settings.nix` provides `username`, `hostname`, `system`, `channel`, `timeZone`, `uid`
- Modules receive `userSettings` via `extraSpecialArgs` (home-manager) or `specialArgs` (system)
- Host-identifying values (hostname, computer name, SMB name, etc.) must use `userSettings.hostname` — never hardcode the hostname string

### Home-Manager Integration

NixOS and darwin hosts use home-manager as a system module (`nixosModules.home-manager` / `darwinModules.home-manager`). This sets `submoduleSupport.enable = true`, which means:

- `programs.home-manager.enable = true` is a **no-op** — it does not install the CLI
- Home-manager config is applied via `nixos-rebuild switch` / `darwin-rebuild switch`, not `home-manager switch`
- `homeManagerHosts` in `flake/hosts.nix` is reserved for standalone hosts (e.g., Arch Linux) without system module integration

## nix-darwin vs NixOS

These are different systems with different option sets. Do not assume NixOS options exist on nix-darwin:

- **NixOS-only**: `initialPassword`, `createHome`, `isNormalUser`, `extraGroups`, `nix.gc.automatic`, `nix.optimise.automatic`
- **nix-darwin-only**: `system.primaryUser`, `users.knownUsers`, `homebrew.*`
- **Both**: `users.users.<name>.uid`, `users.users.<name>.home`, `users.users.<name>.shell`, `environment.shells`, `environment.variables`

## Determinate Nix

EDGE uses Determinate Nix installer, which manages its own daemon and GC. Set `nix.enable = false` — do not configure `nix.gc.*` or `nix.optimise.*` on these hosts.

## Channel Selection

Per-host `user-settings.nix` has a `channel` field (`"stable"` or `"unstable"`). The flake selects the matching nixpkgs, nix-darwin, and home-manager inputs accordingly.

## Package Install Priority (macOS)

1. **home-manager** (`home.packages`, `programs.*`) — CLI tools and configured programs
2. **nix-darwin** (`environment.systemPackages`) — system-level packages
3. **Homebrew** (`homebrew.brews` / `homebrew.casks`) — GUI apps and formulae without nixpkgs equivalents
4. **Mac App Store** (`homebrew.masApps`) — App Store-only apps (e.g., WireGuard)

Do not install GUI apps via nixpkgs on macOS — they lack Spotlight indexing, Gatekeeper integration, and auto-update. Use `homebrew.casks` instead. Never use both nixpkgs and a homebrew cask for the same app.

## Workflow

- When asked to plan: present the plan and wait for explicit approval before implementing
- When creating new modules: follow the `custom.*.enable` pattern above
- When adding a module to a host: import in `default.nix` AND set `custom.*.enable = true`
- When adding new modules or hosts: update the module tables in `NIXOS.md`, `HOME-MANAGER.md`, or `DARWIN.md` and the hosts tables in `README.md` as part of the same change
