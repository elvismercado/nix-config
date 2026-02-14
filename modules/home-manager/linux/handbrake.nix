# HandBrake — video transcoder
#
# GUI tool for converting video files and ripping DVDs.
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/handbrake.nix ];
#   custom.hmHandbrake.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.hmHandbrake.enable = lib.mkEnableOption "enables HandBrake video transcoder";
  };

  config = lib.mkIf config.custom.hmHandbrake.enable {
    home.packages = [
      pkgs.handbrake
    ];
  };
}
