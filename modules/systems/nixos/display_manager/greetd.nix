# greetd + ReGreet — display manager with GTK4 greeter (Sway compositor)
# https://github.com/regreet/regreet
# https://wiki.nixos.org/wiki/Greetd
#
# Enables greetd with ReGreet, a clean GTK4 graphical greeter, running
# inside a minimal Sway session. Using Sway (instead of Cage) provides
# full multi-monitor support: per-output resolution, position, rotation.
#
# Sessions are auto-detected from .desktop files installed by desktop
# environment modules (e.g. kde_plasma.nix installs plasma.desktop).
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/display_manager/greetd.nix
#     ../../../modules/systems/nixos/desktop_environment/kde_plasma.nix
#   ];
#   custom.greetd.enable = true;
#   custom.kdePlasma.enable = true;
#
#   # Multi-monitor layout (sway output commands)
#   custom.greetd.swayOutputConfig = ''
#     output DP-1 mode 2560x1440@100Hz position 0 0
#     output DP-2 mode 1920x1200@100Hz transform 270 position 2560 0
#   '';
#
#   # Optional: login screen wallpaper
#   custom.greetd.background = ./wallpaper.jpg;

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.greetd;

  tomlFormat = pkgs.formats.toml { };

  # ReGreet TOML configuration
  regreetConfig = tomlFormat.generate "regreet.toml" (
    {
      GTK = {
        cursor_theme_name = "breeze_cursors";
        icon_theme_name = "breeze";
      };
    }
    // lib.optionalAttrs (cfg.background != null) {
      background = {
        path = "${cfg.background}";
        fit = "Cover";
      };
    }
  );

  # Minimal Sway config for the greeter session
  swayGreeterConfig = pkgs.writeText "greetd-sway-config" ''
    # Output layout (resolution, position, rotation)
    ${cfg.swayOutputConfig}

    # Cursor theme
    seat seat0 xcursor_theme breeze_cursors 24

    # Disable unneeded desktop features
    xwayland disable

    # Launch ReGreet, exit Sway when done
    exec "${pkgs.regreet}/bin/regreet --config ${regreetConfig}; swaymsg exit"
  '';
in
{
  options = {
    custom.greetd.enable = lib.mkEnableOption "enables greetd display manager with ReGreet greeter (Sway compositor)";

    custom.greetd.background = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional path to a background image for the ReGreet login screen.
        Supports JPEG, PNG, and other formats handled by GTK4.
        When null, ReGreet uses its default background.
      '';
    };

    custom.greetd.swayOutputConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        output DP-1 mode 2560x1440@100Hz position 0 0
        output DP-2 mode 1920x1200@100Hz transform 270 position 2560 0
      '';
      description = ''
        Sway output configuration lines for the greeter session.
        Controls monitor resolution, position, and rotation on the
        login screen. Each line should be a sway `output` command.
        If empty, Sway uses auto-detected defaults.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway --config ${swayGreeterConfig}";
          user = "greeter";
        };
      };
    };

    # Give the greeter user immediate GPU access (avoids waiting for logind seat assignment)
    users.users.greeter.extraGroups = [ "video" ];

    # Required packages for the greeter session
    environment.systemPackages = [
      pkgs.sway
      pkgs.regreet
      pkgs.kdePackages.breeze
      pkgs.kdePackages.breeze-icons
    ];
  };
}
