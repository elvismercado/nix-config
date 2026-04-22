# Linux-only shell aliases
#
# Provides the `postinstall` alias and NixOS switch/rebuild aliases
# (`switch`, `switchbuild`, `switchtest`, `switchhealth`, `switchhelp`).
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/aliases.nix ];
#   custom.hmLinuxAliases.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.hmLinuxAliases.enable = lib.mkEnableOption "enables Linux-specific shell aliases";
  };

  config = lib.mkIf config.custom.hmLinuxAliases.enable {
    home.shellAliases = {
      postinstall = "bash ${config.home.homeDirectory}/git/nix-config/scripts/nixos/postinstall.sh";
      switch = "cd ${config.home.homeDirectory}/git/nix-config && sudo nixos-rebuild switch --flake .#${userSettings.hostname}";
      switchbuild = "cd ${config.home.homeDirectory}/git/nix-config && nixos-rebuild build --flake .#${userSettings.hostname}";
      switchtest = "cd ${config.home.homeDirectory}/git/nix-config && sudo nixos-rebuild dry-activate --flake .#${userSettings.hostname}";
      switchhealth = "{ echo '=== Failed units ==='; systemctl --failed; echo '=== Boot errors ==='; journalctl -b -p err --no-pager; echo '=== Boot warnings ==='; journalctl -b -p warning --no-pager; echo '=== Kernel hardware issues ==='; sudo dmesg --level=err,warn; echo '=== OOM events ==='; journalctl -b --no-pager | grep -i 'out of memory\|oom-kill\|killed process' || echo 'None'; echo '=== NVIDIA GPU ==='; nvidia-smi 2>/dev/null || echo 'nvidia-smi not available'; echo '=== Disk usage ==='; df -h / /home /boot; echo '=== Nix store size ==='; du -sh /nix/store 2>/dev/null; echo '=== NixOS generation ==='; nixos-rebuild list-generations --no-build-nix 2>/dev/null | tail -5; } > /tmp/health.txt 2>&1 && echo \"Saved to /tmp/health.txt ($(wc -l < /tmp/health.txt) lines)\"";
      switchhelp = "echo -e '\n  switch        — Rebuild and activate system config\n                  sudo nixos-rebuild switch --flake .#${userSettings.hostname}\n  switchbuild   — Build config without activating\n                  nixos-rebuild build --flake .#${userSettings.hostname}\n  switchtest    — Test build (dry-activate)\n                  sudo nixos-rebuild dry-activate --flake .#${userSettings.hostname}\n  switchcheck   — Validate flake\n                  nix flake check\n  switchupdate  — Update flake inputs\n                  nix flake update\n  switchhealth  — Save system health report to /tmp/health.txt\n  switchcd      — cd to nix-config repo\n  switchhelp    — Show this help\n'";
    };
  };
}
