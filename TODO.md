# nix-config — Improvement Backlog

Comprehensive audit findings for iterative improvement. Check items off as they are completed.

---

## Completed — Round 1

<details>
<summary>P1–P5: 43 items (all completed)</summary>

### P1 — Security & Correctness

- [x] **install.sh: Hardcoded UID 1000:100** — `deploy_repo()` uses `chown -R 1000:100`. Read from `user-settings.nix` `uid` field instead.
- [x] **install.sh: No disk space validation** — EFI + swap + home could exceed disk size, causing confusing `parted` errors. Validate before destructive operations.
- [x] **install.sh: Late `--host` validation** — `--host` value not validated until `resolve_username()`. User goes through disk prompts before learning the host doesn't exist. Validate right after `clone_repo`.
- [x] **ssh-server.nix: Permissive SSH defaults** — `PasswordAuthentication = true` and `AllowUsers = null` (allows all users). Consider key-only default or restrict `AllowUsers` to `userSettings.username`.

### P2 — Robustness & Reliability

- [x] **install.sh: Replace `sleep 2` with `udevadm settle`** — After `partprobe`, use `udevadm settle` for deterministic partition readiness instead of a fixed sleep.
- [x] **install.sh: Add cleanup trap on failure** — If the script fails mid-install, mounts under `/mnt` are left active. Add a trap that runs `umount -R /mnt; swapoff -a` on ERR exit.
- [x] **install.sh: Replace `eval` with `printf -v`** — `prompt_size` and `prompt_disk` use `eval` to set variables by name. `printf -v "$varname" '%s' "$value"` is safer.
- [x] **install.sh: Validate minimum EFI partition size** — A user could specify `--efi-size 1M` which is too small for FAT32. Enforce a minimum.
- [x] **postinstall.sh: Validate hostname matches flake host** — `hostname` could differ from the flake host name. Check `hosts/${HOST}/` exists before `nixos-rebuild`.
- [x] **postinstall.sh: Add `--title` to `gh ssh-key add`** — Won't fix: `gh ssh-key add` already uses the key comment (`${USER}@hostname-date`) as the GitHub title automatically.
- [x] **postinstall.sh: Validate not running as root** — `passwd` and `$HOME` would target the wrong user if run as root.

### P3 — Architecture & Convention

- [x] **Remove unused `mac-app-util` flake input** — Declared in `flake.nix` but never consumed in any module. Adds to `flake.lock` weight and update time.
- [x] **Add `determinate` darwin module to EDGE** — `flake/nixos.nix` includes `determinate.nixosModules.default` for NixOS hosts. `flake/darwin.nix` is missing `determinate.darwinModules.default` for EDGE.
- [x] **Document `plasma-manager` stable-only constraint** — `plasma-manager` follows `nixpkgs-stable` / `home-manager-stable`. If a NixOS host ever uses `channel = "unstable"`, there will be a version mismatch.
- [x] **Make `plasma-manager` conditional on DE** — Currently loaded for all NixOS hosts via `home-manager.sharedModules` regardless of desktop environment. Should be conditional.
- [x] **Remove dead `garbage.nix` import from EDGE** — `hosts/EDGE/configuration/default.nix` imports `garbage.nix` but it can never be enabled (`nix.enable = false`). Remove the import.
- [x] **Use `userSettings.system` for EDGE `hostPlatform`** — `hosts/EDGE/configuration/configuration.nix` hardcodes `"x86_64-darwin"` instead of using `userSettings.system`.
- [x] **Extract duplicated switch aliases to shared module** — `switch`, `switchbuild`, `switchtest`, `switchhealth`, `switchhelp` are copy-pasted across all 3 host `home.nix` files. Extract to a shared module with a platform toggle.
- [x] **Move duplicated `trusted-users` to flake-level builder** — `nix.settings.trusted-users` is identical in both NixOS `user.nix` files. Move to `flake/nixos.nix`.
- [x] **Make repo path configurable** — `~/git/nix-config` is hardcoded in `postinstall.nix`, `aliases.nix` (`switchcd`, `switchupdate`, `switchcheck`). Add a configurable option with this as the default.

### P4 — Module Quality

- [x] **Add comment headers to 13 modules** — Missing purpose + Usage block: `base.nix`, `packages.nix`, `vscode.nix`, `bash.nix`, `brave.nix`, `syncthing.nix`, `thunderbird.nix`, `nextcloud.nix`, `docker.nix`, `mullvad.nix`, `garbage.nix` (shared), `packages.nix` (shared), partial `aliases.nix`.
- [x] **Standardise option prefixes** — All modules now use prefixed naming: `hm*` (home-manager), `sys*` (shared system), `sysDar*` (darwin system), `sysNix*` (NixOS system). Updated all module files, host configs, and documentation.
- [x] **Deduplicate `nil` package** — Removed from `vscode.nix`; kept in `base.nix` where it's available to all hosts.
- [x] **Remove `mpv` from `packages.nix`** — Removed from `packages.nix`; JIN now imports `mpv.nix` module (FENNEC already had it, EDGE uses Homebrew brew).
- [x] **Move Linux-only packages from `all/packages.nix` to `linux/`** — Created `linux/packages.nix` (`custom.hmLinuxPackages`) with 6 Linux-only packages; `all/packages.nix` now only has cross-platform packages.
- [x] **Add platform guard to `vscode.nix` and `nextcloud.nix`** — Moved both from `all/` to `linux/`. macOS hosts use Homebrew casks instead.
- [x] **Move AMD/NVIDIA aliases from `all/` to `linux/`** — Moved `hmAliasesAmdCpu`, `hmAliasesNvidiaGpu`, and `nixdiag` to `linux/aliases.nix`. All use Linux-only commands.
- [x] **Move `cowsay`/`lolcat` out of `base.nix`** — Moved to `all/packages.nix`, then merged `all/packages.nix` into `all/base.nix` (eliminated redundant module). Moved 4 GUI apps (`localsend`, `mullvad-vpn`, `handbrake`, `moonlight-qt`) to `linux/packages.nix` to avoid Homebrew conflicts on macOS.
- [x] **Make `EDITOR` configurable in `base.nix`** — Added `custom.hmBase.editor` option (default `"nano"`). Used by `base.nix` (`EDITOR` env var) and `git.nix` (`core.editor`).
- [x] **Use declarative `programs.thunderbird` in `thunderbird.nix`** — Switched from raw `home.packages` to `programs.thunderbird.enable` with a default profile. Removed commented-out account config. Hunspell dictionaries kept in `home.packages`.
- [x] **Clean up commented-out code** — Removed dead commented-out blocks from 8 files: `vscode.nix` (editor/formatter settings), `sunshine.nix` (preset config), `syncthing.nix` (optional settings), `bash.nix` (`shellOptions`), `nextcloud.nix` (`startInBackground`), `linux/packages.nix` (alt packages), `base.nix` (headsetcontrol variants), `aliases.nix` (dead aliases). Kept deliberate notes with inline explanations.
- [x] **Conditionally enable `plasma-browser-integration` in `brave.nix`** — Auto-detects `desktopEnvironment = "kde-plasma"` from `userSettings` and includes `plasma-browser-integration` in `nativeMessagingHosts`.
- [x] **Add docker group membership to `docker.nix`** — Module now adds the user to the `docker` group automatically via `userSettings.username`. Removed redundant manual entry from JIN's `user.nix`.
- [x] **Add Determinate Nix guard to shared `garbage.nix`** — Auto-disables GC/optimise when `nix.enable = false` (Determinate Nix hosts). Enabling `custom.sysGc` is a safe no-op on those hosts.
- [x] **Add comment for `syncthing.nix` `urAccepted = -1`** — Added inline comment explaining `-1` means opt-out of anonymous usage reporting.

### P5 — Script Polish

- [x] **install.sh: Handle `/tmp/nix-config` collision** — Stale `/tmp/nix-config` from interrupted runs is now removed before cloning. Replaced unreliable `git pull` fallback with delete + fresh clone.
- [x] **install.sh: Add error check after `git clone`** — Added explicit `fatal` message on clone failure instead of relying on cryptic `set -e` exit.
- [x] **install.sh: Gitignore `INSTALL-REPORT.md`** — Already gitignored (`**/INSTALL-REPORT.md` in `.gitignore`).
- [x] **setup.sh: Add timeout to `xcode-select --install` polling** — Added 15-minute timeout (180 iterations × 5s). Exits with a clear error and manual install instructions if timed out.
- [x] **setup.sh: Align clone method with `install.sh`** — Switched from `gh repo clone` (requires auth) to `git clone` with HTTPS URL. Existing repo prompts user before deletion. Added clone failure error check.
- [x] **bash.nix: Remove debug echo** — Won't fix: echos are intentional hook references. All four `programs.bash` hooks (`bashrcExtra`, `initExtra`, `profileExtra`, `logoutExtra`) are covered.
- [x] **JIN `default.nix`: Fix stale `gfxmodeEfi` comment** — Updated value to full resolution chain (`3840x2160,2560x1440,1920x1200,1920x1080,auto`) and fixed comment. Removed stale commented-out line.
- [x] **Move group membership into system modules** — `libvirtd` and `adbusers` auto-added by their modules. Created `embedded.nix` (`custom.sysNixEmbedded`) for `dialout` group + `arduino-ide`. Removed all three from JIN's `user.nix`.

</details>

---

## Round 2

### P1 — Security & Correctness

- [x] **install.sh: Validate extracted USERNAME** — `resolve_username()` now validates `USERNAME` matches `^[a-z_][a-z0-9_-]{0,31}$` (POSIX) and `USER_UID` is in range 1000–65533. Defense-in-depth before values are interpolated into shell paths.
- [x] **install.sh: Add timeout to `udevadm settle`** — Both `udevadm settle` calls now use `--timeout=30` to fail fast on a stuck udev queue instead of hanging silently for 3 minutes.
- [x] **flake/hosts.nix: Assert valid channel value** — `mkHost` now validates `userSettings.channel` is `"stable"` or `"unstable"` and `throw`s a clear error at flake evaluation otherwise. Catches typos before any rebuild starts.

### P2 — Robustness & Reliability

- [x] **install.sh: Validate `nixos-generate-config` output** — `generate_hardware_config()` now fails fast with a clear message if the command fails, the file is empty, or the file is missing `fileSystems` definitions.
- [ ] **install.sh: Use `mktemp` for temporary repo** — `TEMP_REPO="/tmp/${REPO_NAME}"` is predictable. Concurrent installs or a malicious symlink at `/tmp/nix-config` could cause issues. Use `mktemp -d` instead.
- [ ] **setup.sh: Validate Determinate Nix installer download** — `curl | sh` pipe (line ~60) has no checksum verification. Same for Homebrew installer (line ~113). Add `--fail` flag at minimum and check exit code.

### P3 — Architecture & Convention

- [ ] **Add comment headers to 16 modules** — Missing purpose + Usage block: `android.nix`, `shared/bash.nix`, `shared/fonts.nix`, `darwin/fonts.nix`, `darwin/garbage.nix`, `darwin/packages.nix`, `nixos/fwupd.nix`, `nixos/printing.nix`, `nixos/apps/coolercontrol.nix`, `nixos/apps/sunshine.nix`, `nixos/desktop_environment/kde_plasma.nix`, `nixos/input/wacom.nix`, `nixos/mouse/logitech.nix`, `nixos/security/fprintd.nix`, `nixos/security/yubikey.nix`, `darwin/alacritty.nix` (has comment but no Usage block).
- [ ] **Remove unnecessary `lib.mkDefault` on NixOS home.nix** — FENNEC and JIN `home.nix` use `lib.mkDefault` for `home.username` and `home.homeDirectory`. On NixOS with home-manager as a module, these are auto-derived — `lib.mkDefault` is unnecessary (harmless but inconsistent with EDGE which correctly omits it).
- [ ] **Add section comments to EDGE home-manager imports** — FENNEC and JIN `home-manager/default.nix` use section comments (`# Base`, `# Shell`, `# Apps`). EDGE lacks these, making the import list harder to navigate.
- [ ] **Add section comments to EDGE configuration imports** — FENNEC and JIN `configuration/default.nix` have detailed section comments. EDGE's is uncommented — add `# System`, `# Darwin`, `# Shared` groupings.

### P4 — Module Quality

- [ ] **Decide host-level module coverage** — Several modules are enabled on some hosts but not others without clear justification. Review and decide for each: `fnm.nix` (FENNEC+JIN yes, EDGE no), `pyenv.nix` (FENNEC+JIN yes, EDGE no), `ansible.nix` (EDGE yes, FENNEC+JIN no), `syncthing.nix` (FENNEC yes, JIN+EDGE no). Either enable consistently or document why each host differs.
- [ ] **enable-flakes.nix: Clean up stale comments** — Lines 2–6 contain commented-out examples and notes about other distros / Determinate Nix. Module header should follow standard pattern; move reference notes to docs or inline.
- [ ] **Deduplicate FENNEC/JIN `user.nix`** — Both NixOS `user.nix` files are near-identical (`mutableUsers`, `defaultUserShell`, `isNormalUser`, `initialPassword`, `useDefaultShell`, `networking.hostName`). Extract common config to a shared NixOS user module, with host-specific `extraGroups` merged in.
- [ ] **Deduplicate FENNEC/JIN `configuration.nix`** — Both set `system.stateVersion`, `nixpkgs.config.allowUnfree`, and `programs.nix-ld.enable` identically. Extract to shared module or flake builder.

### P5 — Script & Documentation Polish

- [ ] **INSTALL.md: Align manual steps with automated script** — Manual "step-by-step" section uses different variable names/calculations than `install.sh`. Users comparing manual vs automated could get confused.
- [ ] **README.md: Document channel selection** — Quickstart shows `setup.sh` but doesn't explain how `channel` in `user-settings.nix` selects between stable/unstable. New users won't know how to switch.
- [ ] **setup.sh: Consistent error handling pattern** — Uses `|| { ...; exit 1; }` for git clone but bare `exit 1` for xcode-select timeout. Standardize on one pattern throughout.
