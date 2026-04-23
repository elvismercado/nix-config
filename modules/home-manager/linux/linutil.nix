# LinUtil — desktop shortcut for Chris Titus Tech's Linux Toolbox
#
# Adds an application menu entry that launches LinUtil (TUI) in a terminal
# via the stable curl one-liner. Requires internet access.
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/linutil.nix ];
#   custom.hmLinutil.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmLinutil.enable = lib.mkEnableOption "LinUtil (Chris Titus Tech Linux Toolbox) desktop shortcut";
  };

  config = lib.mkIf config.custom.hmLinutil.enable {
    xdg.desktopEntries = {
      linutil = {
        name = "LinUtil";
        comment = "Chris Titus Tech's Linux Toolbox — system setup and optimization";
        exec = "bash -c \"curl -fsSL https://christitus.com/linux | sh\"";
        icon = "utilities-terminal";
        categories = [
          "System"
          "Utility"
        ];
        terminal = true;
      };
    };

    # Place shortcut on the KDE desktop
    home.file."Desktop/linutil.desktop" = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=LinUtil
        Comment=Chris Titus Tech's Linux Toolbox — system setup and optimization
        Exec=bash -c "curl -fsSL https://christitus.com/linux | sh"
        Icon=utilities-terminal
        Categories=System;Utility;
        Terminal=true
      '';
      executable = true;
    };
  };
}
