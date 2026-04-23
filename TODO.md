# nix-config — Improvement Backlog

Comprehensive audit findings for iterative improvement. Check items off as they are completed.

## P1 — Security & Correctness

- [x] **install.sh: Hardcoded UID 1000:100** — `deploy_repo()` uses `chown -R 1000:100`. Read from `user-settings.nix` `uid` field instead.
- [x] **install.sh: No disk space validation** — EFI + swap + home could exceed disk size, causing confusing `parted` errors. Validate before destructive operations.
- [x] **install.sh: Late `--host` validation** — `--host` value not validated until `resolve_username()`. User goes through disk prompts before learning the host doesn't exist. Validate right after `clone_repo`.
- [x] **ssh-server.nix: Permissive SSH defaults** — `PasswordAuthentication = true` and `AllowUsers = null` (allows all users). Consider key-only default or restrict `AllowUsers` to `userSettings.username`.

## P2 — Robustness & Reliability

- [x] **install.sh: Replace `sleep 2` with `udevadm settle`** — After `partprobe`, use `udevadm settle` for deterministic partition readiness instead of a fixed sleep.
- [x] **install.sh: Add cleanup trap on failure** — If the script fails mid-install, mounts under `/mnt` are left active. Add a trap that runs `umount -R /mnt; swapoff -a` on ERR exit.
- [x] **install.sh: Replace `eval` with `printf -v`** — `prompt_size` and `prompt_disk` use `eval` to set variables by name. `printf -v "$varname" '%s' "$value"` is safer.
- [x] **install.sh: Validate minimum EFI partition size** — A user could specify `--efi-size 1M` which is too small for FAT32. Enforce a minimum.
- [x] **postinstall.sh: Validate hostname matches flake host** — `hostname` could differ from the flake host name. Check `hosts/${HOST}/` exists before `nixos-rebuild`.
- [x] **postinstall.sh: Add `--title` to `gh ssh-key add`** — Won't fix: `gh ssh-key add` already uses the key comment (`${USER}@hostname-date`) as the GitHub title automatically.
- [x] **postinstall.sh: Validate not running as root** — `passwd` and `$HOME` would target the wrong user if run as root.

## P3 — Architecture & Convention

- [x] **Remove unused `mac-app-util` flake input** — Declared in `flake.nix` but never consumed in any module. Adds to `flake.lock` weight and update time.
- [x] **Add `determinate` darwin module to EDGE** — `flake/nixos.nix` includes `determinate.nixosModules.default` for NixOS hosts. `flake/darwin.nix` is missing `determinate.darwinModules.default` for EDGE.
- [x] **Document `plasma-manager` stable-only constraint** — `plasma-manager` follows `nixpkgs-stable` / `home-manager-stable`. If a NixOS host ever uses `channel = "unstable"`, there will be a version mismatch.
- [x] **Make `plasma-manager` conditional on DE** — Currently loaded for all NixOS hosts via `home-manager.sharedModules` regardless of desktop environment. Should be conditional.
- [x] **Remove dead `garbage.nix` import from EDGE** — `hosts/EDGE/configuration/default.nix` imports `garbage.nix` but it can never be enabled (`nix.enable = false`). Remove the import.
- [x] **Use `userSettings.system` for EDGE `hostPlatform`** — `hosts/EDGE/configuration/configuration.nix` hardcodes `"x86_64-darwin"` instead of using `userSettings.system`.
- [x] **Extract duplicated switch aliases to shared module** — `switch`, `switchbuild`, `switchtest`, `switchhealth`, `switchhelp` are copy-pasted across all 3 host `home.nix` files. Extract to a shared module with a platform toggle.
- [x] **Move duplicated `trusted-users` to flake-level builder** — `nix.settings.trusted-users` is identical in both NixOS `user.nix` files. Move to `flake/nixos.nix`.
- [x] **Make repo path configurable** — `~/git/nix-config` is hardcoded in `postinstall.nix`, `aliases.nix` (`switchcd`, `switchupdate`, `switchcheck`). Add a configurable option with this as the default.

## P4 — Module Quality

- [x] **Add comment headers to 13 modules** — Missing purpose + Usage block: `base.nix`, `packages.nix`, `vscode.nix`, `bash.nix`, `brave.nix`, `syncthing.nix`, `thunderbird.nix`, `nextcloud.nix`, `docker.nix`, `mullvad.nix`, `garbage.nix` (shared), `packages.nix` (shared), partial `aliases.nix`.
- [x] **Standardise option prefixes** — All modules now use prefixed naming: `hm*` (home-manager), `sys*` (shared system), `sysDar*` (darwin system), `sysNix*` (NixOS system). Updated all module files, host configs, and documentation.
- [x] **Deduplicate `nil` package** — Removed from `vscode.nix`; kept in `base.nix` where it's available to all hosts.
- [x] **Remove `mpv` from `packages.nix`** — Removed from `packages.nix`; JIN now imports `mpv.nix` module (FENNEC already had it, EDGE uses Homebrew brew).
- [x] **Move Linux-only packages from `all/packages.nix` to `linux/`** — Created `linux/packages.nix` (`custom.hmLinuxPackages`) with 6 Linux-only packages; `all/packages.nix` now only has cross-platform packages.
- [x] **Add platform guard to `vscode.nix` and `nextcloud.nix`** — Moved both from `all/` to `linux/`. macOS hosts use Homebrew casks instead.
- [x] **Move AMD/NVIDIA aliases from `all/` to `linux/`** — Moved `hmAliasesAmdCpu`, `hmAliasesNvidiaGpu`, and `nixdiag` to `linux/aliases.nix`. All use Linux-only commands.
- [ ] **Move `cowsay`/`lolcat` out of `base.nix`** — Novelty packages don't belong in the base config. Move to `packages.nix` or a separate module.
- [ ] **Make `EDITOR` configurable in `base.nix`** — `EDITOR = "nano"` is hardcoded. Add a `custom.hmBase.editor` option with `"nano"` as default.
- [ ] **Use declarative `programs.thunderbird` in `thunderbird.nix`** — Currently installed as a raw package with the declarative config commented out. Switch to the home-manager module.
- [ ] **Clean up commented-out code** — Large commented-out blocks in `vscode.nix` (editor/formatter settings) and `packages.nix` (multiple packages). Remove or track in issues.
- [ ] **Conditionally enable `plasma-browser-integration` in `brave.nix`** — KDE integration is commented out. Could be conditionally enabled based on desktop environment.
- [ ] **Add docker group membership to `docker.nix`** — Module enables Docker but doesn't add the user to the `docker` group. User can't use docker without sudo.
- [ ] **Add Determinate Nix guard to shared `garbage.nix`** — No assertion or documentation warning about incompatibility with `nix.enable = false` (Determinate Nix).
- [ ] **Add comment for `syncthing.nix` `urAccepted = -1`** — Missing explanation that `-1` means opt-out of usage reporting.

## P5 — Script Polish

- [ ] **install.sh: Handle `/tmp/nix-config` collision** — A previous interrupted run could leave a corrupt/stale clone. Fresh clone or explicit cleanup instead of `git pull`.
- [ ] **install.sh: Add error check after `git clone`** — Clone failure is not caught; script continues and fails later with a confusing error.
- [ ] **install.sh: Gitignore `INSTALL-REPORT.md`** — `write_report()` creates an untracked file inside the repo. Add to `.gitignore` or document.
- [ ] **setup.sh: Add timeout to `xcode-select --install` polling** — Loops forever if the user cancels the Xcode dialog. Add a max iteration count.
- [ ] **setup.sh: Align clone method with `install.sh`** — `setup.sh` uses `gh repo clone` (requires auth) while `install.sh` uses `git clone` (no auth needed). Inconsistent.
- [ ] **bash.nix: Remove debug echo** — `echo "Hello HOSTNAME"` runs on every shell open including subshells. Remove or gate behind a debug flag.
- [ ] **JIN `default.nix`: Fix stale `gfxmodeEfi` comment** — Comment describes old 4K value, not the current `"1920x1080,auto"` value.
