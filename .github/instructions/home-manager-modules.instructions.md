---
applyTo: "modules/home-manager/**,hosts/*/home-manager/**,flake/darwin.nix,flake/home.nix"
description: "Home-manager module patterns and API conventions"
---

## Home-Manager Module API

### Deprecation Awareness

Home-manager stable has restructured many `programs.*` modules. Top-level convenience options often move to nested structures between releases. Before using any `programs.<name>.*` option, verify it is current — don't assume the NixOS wiki or older examples reflect the stable channel API. Check for deprecation warnings after `switch`.

### programs.ssh

Options like `addKeysToAgent`, `serverAliveInterval`, `controlMaster`, `controlPath`, `controlPersist`, `hashKnownHosts`, `serverAliveCountMax` are per-host options — place them in `programs.ssh.matchBlocks."*"` (not top-level `programs.ssh`).

Set `programs.ssh.enableDefaultConfig = false` to avoid deprecation warnings about implicit defaults.

### File Conflicts (backupFileExtension)

When home-manager manages dotfiles (e.g., `~/.ssh/config`), activation fails if the file already exists. Always set `home-manager.backupFileExtension` in the flake integration:

- `flake/darwin.nix`: `home-manager.backupFileExtension = "backup";`
- `flake/nixos.nix`: `home-manager.backupFileExtension = "backup";`

### home.homeDirectory / home.username

On nix-darwin, set these directly without `lib.mkDefault` — they are not auto-derived from system config the way they are on NixOS.

### programs.git

Use `programs.git.settings` (not the deprecated top-level options):

- `userName` → `settings.user.name`
- `userEmail` → `settings.user.email`
- `aliases` → `settings.alias`
- `extraConfig` → merge directly into `settings`

Delta is a separate program — use `programs.delta.enable`, `programs.delta.options`, and set `programs.delta.enableGitIntegration = true` explicitly (not `programs.git.delta`).

### Package Names

nixpkgs renames packages between releases (e.g., `strawberry-qt6` → `strawberry`). Some packages are bundled — e.g., `kwrite` is not a separate attribute, it ships inside `kate`. Before using a package name in `home.packages` or `excludePackages`, verify the attribute exists in the current nixpkgs channel. Check [search.nixos.org](https://search.nixos.org/packages) or use `nix eval nixpkgs#<name>` to confirm.

### Desktop Entries vs Desktop Icons (KDE)

`xdg.desktopEntries` creates files in `~/.local/share/applications/` — these appear in the **KDE app menu/launcher** only.

To also show icons on the **KDE desktop surface**, add `home.file."Desktop/<name>.desktop"` entries pointing to `~/Desktop/`. These are separate locations — both are needed if you want an app in the menu AND on the desktop. Use `text` + `executable = true` to avoid KDE's "untrusted file" dialog.

### plasma-manager Limitations

- **Launcher favorites**: plasma-manager cannot set kickoff/kickerdash favorites. KDE stores them in `kactivitymanagerd-statsrc` with a per-instance UUID that changes on each `nixos-rebuild switch`. Use `iconTasks.launchers` on the task manager dock instead.
- **Camera indicator**: `org.kde.plasma.cameraindicator` only detects apps using the XDG Camera Portal (PipeWire camera API). Standalone webcam apps (Kamoso, Webcamoid, Cheese) access `/dev/video*` directly and never trigger it. It only activates for browser WebRTC video calls.

### Bash Shell Hooks (profileExtra vs initExtra)

Linux terminal emulators (Konsole, GNOME Terminal) open interactive-only shells — `profileExtra` is skipped. Only `initExtra` and `bashrcExtra` run. Place startup commands (like fastfetch) in `initExtra`, not `profileExtra`. macOS Terminal.app and SSH sessions are login shells and run all hooks.
