# Plasma Desktop Configuration — macOS-style panel layout
# https://github.com/nix-community/plasma-manager
#
# Configures a macOS-inspired two-panel layout:
#   - Top panel: menu bar with Global Menu, System Tray, and Digital Clock
#   - Bottom panel: floating dock with Icons-only Task Manager
#
# Also sets:
#   - Window buttons on the right (standard convention)
#   - KRunner centered (Spotlight-style)
#   - Single-click to open files/folders
#   - No splash screen (Plymouth handles the boot splash)
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/plasma-config.nix ];
#   custom.plasmaConfig.enable = true;

{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  options = {
    custom.plasmaConfig.enable = lib.mkEnableOption "enables macOS-style Plasma desktop configuration";
  };

  config = lib.mkIf config.custom.plasmaConfig.enable {
    assertions = [
      {
        assertion = (userSettings.desktopEnvironment or null) == "kde-plasma";
        message = "custom.plasmaConfig requires KDE Plasma (set desktopEnvironment = \"kde-plasma\" in user-settings.nix)";
      }
    ];
    # Webcam app (Qt, replaces Kamoso)
    home.packages = [
      pkgs.webcamoid
    ];

    programs.plasma = {
      enable = true;

      # ── Panels ──────────────────────────────────────────────────────
      panels = [
        # Top panel — menu bar
        {
          location = "top";
          height = 28;
          lengthMode = "fill";
          floating = false;
          widgets = [
            # App launcher — uncomment ONE of the following:
            # "org.kde.plasma.kickoff"        # Kickoff: traditional start menu
            # "org.kde.plasma.kicker" # Application Menu: compact cascading menu
            "org.kde.plasma.kickerdash" # Application Dashboard: full-screen grid (Launchpad-style)

            # Global Menu — shows the focused window's menu bar
            "org.kde.plasma.appmenu"

            # Flexible spacer pushes the rest to the right
            "org.kde.plasma.panelspacer"

            # System Tray — network, volume, notifications, etc.
            {
              systemTray = {
                icons.scaleToFit = true;
                items = {
                  shown = [
                    "org.kde.plasma.bluetooth"
                    "org.kde.plasma.cameraindicator"
                    "org.kde.plasma.lock_keys"
                  ];
                };
              };
            }

            # Clock
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
              };
            }

            # Peek at / show desktop
            "org.kde.plasma.showdesktop"
          ];
        }

        # Bottom panel — floating app dock
        {
          location = "bottom";
          height = 56;
          floating = true;
          alignment = "center";
          lengthMode = "fit";
          hiding = "dodgewindows"; # slides away when a window touches it
          widgets = [
            {
              iconTasks = {
                launchers = [
                  "applications:systemsettings.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "preferred://browser"
                ];
              };
            }
          ];
        }
      ];

      # ── Window Management ───────────────────────────────────────────
      kwin = {
        tiling.padding = 4; # 4px gap between tiled windows

        titlebarButtons = {
          left = [ ];
          right = [
            "minimize"
            "maximize"
            "close"
          ];
        };
      };

      # ── KRunner ─────────────────────────────────────────────────────
      krunner = {
        position = "center"; # centered like Spotlight
        historyBehavior = "enableSuggestions";
      };

      # ── Workspace ───────────────────────────────────────────────────
      workspace = {
        clickItemTo = "open"; # single-click to open (macOS default)
        splashScreen.theme = "None"; # Plymouth handles boot splash
      };
    };
  };
}
