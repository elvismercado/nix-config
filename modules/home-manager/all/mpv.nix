# mpv — lightweight video player
#
# Keyboard-driven media player with wide format support.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/mpv.nix ];
#   custom.hmMpv.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmMpv.enable = lib.mkEnableOption "mpv lightweight keyboard-driven video player";
  };

  config = lib.mkIf config.custom.hmMpv.enable {
    programs.mpv.enable = true;
  };
}
