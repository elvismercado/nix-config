# Steam — gaming platform with Proton, GameMode, Gamescope, MangoHud, and Lutris
#
# Enables Steam with GE-Proton for broad game compatibility, GameMode for
# CPU/GPU performance tuning, Gamescope for resolution scaling and HDR,
# MangoHud for FPS/performance overlays, and Lutris for non-Steam games
# (Epic, GOG, Battle.net, standalone Windows games).
#
# Steam launch options (set per-game in Properties → Launch Options):
#   gamemoderun %command%              — enable GameMode performance tuning
#   mangohud %command%                 — show FPS/performance overlay
#   gamemoderun mangohud %command%     — both at once
#   gamescope -- %command%             — run through Gamescope compositor
#   gamescope -W 1920 -H 1080 -f -- %command%  — Gamescope with resolution
#
# Gamescope session (Steam Deck-like boot-to-Steam):
#   Not enabled by default. To enable, add to your host configuration:
#     programs.steam.gamescopeSession.enable = true;
#
# Usage:
#   imports = [ ../../../../modules/systems/nixos/gaming/steam.nix ];
#   custom.steam.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.steam.enable = lib.mkEnableOption "enables Steam with gaming tools";
  };

  config = lib.mkIf config.custom.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;

      # GE-Proton — community Proton builds with extra game fixes and patches.
      # Appears in Steam's per-game compatibility dropdown alongside official Proton versions.
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # GameMode — temporarily optimizes CPU governor, GPU clocks, and niceness
    # while a game is running. Activated per-game via launch options.
    programs.gamemode.enable = true;

    # Gamescope — Valve's micro-compositor for resolution scaling, HDR, VRR,
    # and frame limiting. Available as a tool for launch options.
    programs.gamescope.enable = true;

    # 32-bit graphics libraries — required for Steam's FHS environment.
    # Safe mkDefault: GPU-specific modules (e.g. nvidia_rtx_3080.nix) may
    # already set this; mkDefault avoids conflicts.
    hardware.graphics.enable32Bit = lib.mkDefault true;

    # SteamOS uses this value for maximum game compatibility.
    # Some games crash or stutter with the default kernel value.
    boot.kernel.sysctl."vm.max_map_count" = 2147483642;

    environment.systemPackages = with pkgs; [
      # MangoHud — FPS counter and performance overlay (CPU, GPU, frametime).
      # Activate per-game: mangohud %command%
      mangohud

      # Lutris — open-source game launcher for non-Steam games.
      # Manages Wine/Proton for Epic, GOG, Battle.net, and standalone installers.
      lutris

      # dualsensectl — CLI to control DualSense (PS5) lightbar, mic LED,
      # battery status, and power off.
      dualsensectl
    ];

    # Broader udev rules for controllers outside Steam (emulators, Lutris).
    # Covers PlayStation USB adapters, BigBigWon, and other third-party gamepads.
    services.udev.packages = [ pkgs.game-devices-udev-rules ];
    hardware.uinput.enable = true;
  };
}
