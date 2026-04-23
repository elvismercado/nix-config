# Strawberry — music player for local and network libraries
#
# Qt6/KDE-native music player for managing and playing local or
# NAS-mounted music collections. Supports gapless playback, equalizer,
# and library management.
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/strawberry.nix ];
#   custom.hmStrawberry.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.hmStrawberry.enable = lib.mkEnableOption "Strawberry Qt6/KDE music player for local and network libraries";
  };

  config = lib.mkIf config.custom.hmStrawberry.enable {
    home.packages = [
      pkgs.strawberry
    ];
  };
}
