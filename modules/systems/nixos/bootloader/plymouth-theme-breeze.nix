# KDE Breeze Plymouth Theme
# https://invent.kde.org/plasma/breeze-plymouth
#
# Smooth progress bar in the Breeze visual style. On NixOS, the theme is
# automatically branded with the NixOS logo and distro name.
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/bootloader/plymouth.nix
#     ../../../modules/systems/nixos/bootloader/plymouth-theme-breeze.nix
#   ];
#   custom.plymouth.enable = true;
#   custom.plymouthThemeBreeze.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.plymouthThemeBreeze.enable = lib.mkEnableOption "enables KDE Breeze Plymouth theme";
  };

  config = lib.mkIf config.custom.plymouthThemeBreeze.enable {
    boot.plymouth = {
      theme = "breeze";
      themePackages = [ pkgs.kdePackages.breeze-plymouth ];
    };
  };
}
