# Dock — macOS Dock appearance, behavior, and hot corners
#
# Configures system.defaults.dock with layout, icon size, magnification,
# minimize effect, hot corners, and persistent (pinned) apps.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/dock.nix ];
#   custom.sysDarDock.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarDock.enable = lib.mkEnableOption "macOS Dock appearance, behavior, hot corners, and pinned apps";
  };

  config = lib.mkIf config.custom.sysDarDock.enable {
    system.defaults.dock = {
      # Layout
      orientation = "bottom";
      tilesize = 64;
      magnification = true;
      largesize = 80;

      # Behavior
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      launchanim = true;
      mineffect = "scale";
      minimize-to-application = false;
      show-recents = false;
      show-process-indicators = true;
      showhidden = true;
      mru-spaces = false;
      expose-group-apps = true;

      # Animation speed
      expose-animation-duration = 0.5;

      # Hot corners
      # Values: 1 = disabled, 2 = Mission Control, 3 = Application Windows,
      #         4 = Desktop, 5 = Screen Saver, 6 = Disable Screen Saver,
      #         10 = Put Display to Sleep, 11 = Launchpad, 12 = Notification Center,
      #         13 = Lock Screen
      wvous-tl-corner = 11; # Launchpad
      wvous-tr-corner = 1; # Disabled
      wvous-bl-corner = 2; # Mission Control
      wvous-br-corner = 1; # Disabled

      # Pinned apps (left to right)
      persistent-apps = [
        "/Applications/Brave Browser.app"
        "/Applications/Ferdium.app"
        "/Applications/Beeper Desktop.app"
        "/System/Applications/Utilities/Terminal.app"
        "/Applications/Visual Studio Code.app"
      ];
    };
  };
}
