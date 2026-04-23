# Vesktop — Discord client with Vencord built-in
#
# Open-source Discord client with native screen sharing audio on
# Wayland/PipeWire. Includes Vencord plugins for themes and QoL tweaks.
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/vesktop.nix ];
#   custom.hmVesktop.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.hmVesktop.enable = lib.mkEnableOption "Vesktop Discord client with Vencord and Wayland screen-share audio";
  };

  config = lib.mkIf config.custom.hmVesktop.enable {
    home.packages = [
      pkgs.vesktop
    ];
  };
}
