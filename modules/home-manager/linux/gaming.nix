# Linux gaming — MangoHud overlay and desktop shortcuts for gaming reference sites
#
# Configures MangoHud for FPS/frametime overlays and adds application menu
# entries for ProtonDB, Are We Anti-Cheat Yet, PCGamingWiki, SteamDB, and
# Lutris game install scripts.
#
# MangoHud is activated per-game via Steam launch options:
#   mangohud %command%
#   gamemoderun mangohud %command%
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/gaming.nix ];
#   custom.hmGaming.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmGaming.enable = lib.mkEnableOption "enables gaming desktop shortcuts";
  };

  config = lib.mkIf config.custom.hmGaming.enable {
    # MangoHud — FPS counter and frametime graph overlay.
    # Activate per-game: mangohud %command%
    #
    # Additional settings to add below:
    #   resolution             — display resolution
    #   fps_limit = 144        — cap framerate
    #   font_size = 24         — overlay text size
    #   background_alpha = 0.5 — overlay background transparency
    #   no_display             — hide overlay (logging only)
    #
    # Full reference: https://github.com/flightlessmango/MangoHud#mangohud_config
    programs.mangohud = {
      enable = true;
      settings = {
        fps = true;
        frame_timing = true;
        position = "top-left";
        ram = true;
        vram = true;
        cpu_stats = true;
        cpu_temp = true;
        gpu_stats = true;
        gpu_temp = true;
      };
    };

    xdg.desktopEntries = {
      protondb = {
        name = "ProtonDB";
        comment = "Crowdsourced Linux game compatibility reports";
        exec = "xdg-open https://www.protondb.com";
        icon = "applications-games";
        categories = [ "Game" ];
        terminal = false;
      };

      areweanticheatyet = {
        name = "Are We Anti-Cheat Yet";
        comment = "Anti-cheat compatibility tracker for Linux gaming";
        exec = "xdg-open https://areweanticheatyet.com";
        icon = "applications-games";
        categories = [ "Game" ];
        terminal = false;
      };

      pcgamingwiki = {
        name = "PCGamingWiki";
        comment = "Game fixes, tweaks, launch options, and performance settings";
        exec = "xdg-open https://www.pcgamingwiki.com";
        icon = "applications-games";
        categories = [ "Game" ];
        terminal = false;
      };

      steamdb = {
        name = "SteamDB";
        comment = "Steam pricing history, player counts, and depot info";
        exec = "xdg-open https://steamdb.info";
        icon = "applications-games";
        categories = [ "Game" ];
        terminal = false;
      };

      lutris-web = {
        name = "Lutris Games";
        comment = "Install scripts for non-Steam games";
        exec = "xdg-open https://lutris.net/games";
        icon = "applications-games";
        categories = [ "Game" ];
        terminal = false;
      };
    };

    # Place shortcuts on the KDE desktop
    home.file = {
      "Desktop/protondb.desktop" = {
        text = ''
          [Desktop Entry]
          Type=Application
          Name=ProtonDB
          Comment=Crowdsourced Linux game compatibility reports
          Exec=xdg-open https://www.protondb.com
          Icon=applications-games
          Categories=Game;
          Terminal=false
        '';
        executable = true;
      };
      "Desktop/areweanticheatyet.desktop" = {
        text = ''
          [Desktop Entry]
          Type=Application
          Name=Are We Anti-Cheat Yet
          Comment=Anti-cheat compatibility tracker for Linux gaming
          Exec=xdg-open https://areweanticheatyet.com
          Icon=applications-games
          Categories=Game;
          Terminal=false
        '';
        executable = true;
      };
      "Desktop/pcgamingwiki.desktop" = {
        text = ''
          [Desktop Entry]
          Type=Application
          Name=PCGamingWiki
          Comment=Game fixes, tweaks, launch options, and performance settings
          Exec=xdg-open https://www.pcgamingwiki.com
          Icon=applications-games
          Categories=Game;
          Terminal=false
        '';
        executable = true;
      };
      "Desktop/steamdb.desktop" = {
        text = ''
          [Desktop Entry]
          Type=Application
          Name=SteamDB
          Comment=Steam pricing history, player counts, and depot info
          Exec=xdg-open https://steamdb.info
          Icon=applications-games
          Categories=Game;
          Terminal=false
        '';
        executable = true;
      };
      "Desktop/lutris-web.desktop" = {
        text = ''
          [Desktop Entry]
          Type=Application
          Name=Lutris Games
          Comment=Install scripts for non-Steam games
          Exec=xdg-open https://lutris.net/games
          Icon=applications-games
          Categories=Game;
          Terminal=false
        '';
        executable = true;
      };
    };
  };
}
