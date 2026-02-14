# activation script
# makes aliases to apps so spotlight can find them
# https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3
#
# NOTE: Alacritty is a user-facing app that would normally belong in home.packages,
# but it's placed at system level because `mkalias` requires a system activation
# script to create app aliases for macOS Spotlight indexing.

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.alacritty.enable = lib.mkEnableOption "enables Alacritty terminal";
  };

  config = lib.mkIf config.custom.alacritty.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      mkalias
    ];
  };
}
