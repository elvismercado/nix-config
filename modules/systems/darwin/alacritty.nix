# Alacritty terminal — installed at the system level on macOS
#
# Alacritty is a user-facing app that would normally belong in home.packages,
# but it's placed at system level because `mkalias` requires a system activation
# script to create app aliases for macOS Spotlight indexing.
# See: https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/alacritty.nix ];
#   custom.sysDarAlacritty.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysDarAlacritty.enable = lib.mkEnableOption "enables Alacritty terminal";
  };

  config = lib.mkIf config.custom.sysDarAlacritty.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      mkalias
    ];
  };
}
