# Host-specific Home Manager config for EDGE

{
  config,
  lib,
  userSettings,
  ...
}:

{
  home.username = userSettings.username;
  home.homeDirectory = "/Users/${userSettings.username}";
  home.stateVersion = "25.11";

  home.shellAliases = {
    switch = "cd ${config.home.homeDirectory}/git/nix-config && sudo darwin-rebuild switch --flake .#${userSettings.hostname}";
    switchbuild = "cd ${config.home.homeDirectory}/git/nix-config && darwin-rebuild build --flake .#${userSettings.hostname}";
    switchtest = "cd ${config.home.homeDirectory}/git/nix-config && darwin-rebuild check --flake .#${userSettings.hostname}";
    switchhealth = "{ echo '=== System errors (last 1h) ==='; log show --predicate 'eventType == logEvent && messageType == error' --last 1h --style compact 2>/dev/null | tail -50; echo '=== Disk usage ==='; df -h / /System/Volumes/Data; echo '=== Nix store size ==='; du -sh /nix/store 2>/dev/null; echo '=== Homebrew status ==='; brew doctor 2>&1 | head -20; } > /tmp/health.txt 2>&1 && echo \"Saved to /tmp/health.txt ($(wc -l < /tmp/health.txt) lines)\"";
    switchhelp = "echo -e '\n  switch        — Rebuild and activate system config\n                  sudo darwin-rebuild switch --flake .#${userSettings.hostname}\n  switchbuild   — Build config without activating\n                  darwin-rebuild build --flake .#${userSettings.hostname}\n  switchtest    — Test build (check)\n                  darwin-rebuild check --flake .#${userSettings.hostname}\n  switchcheck   — Validate flake\n                  nix flake check\n  switchupdate  — Update flake inputs\n                  nix flake update\n  switchhealth  — Save system health report to /tmp/health.txt\n  switchcd      — cd to nix-config repo\n  switchhelp    — Show this help\n'";
  };
}
