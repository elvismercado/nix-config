# KDE Breeze GRUB Theme
# https://invent.kde.org/plasma/breeze-grub
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub-theme-breeze.nix ];
#   custom.grubThemeBreeze.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.grubThemeBreeze.enable = lib.mkEnableOption "enables KDE Breeze GRUB theme";
  };

  config = lib.mkIf config.custom.grubThemeBreeze.enable {
    boot.loader.grub.theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
  };
}
