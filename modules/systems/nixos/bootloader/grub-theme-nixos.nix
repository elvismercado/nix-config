# NixOS GRUB Theme
# Default NixOS-branded GRUB theme from nixpkgs.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub-theme-nixos.nix ];
#   custom.grubThemeNixos.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.grubThemeNixos.enable = lib.mkEnableOption "enables NixOS GRUB theme";
  };

  config = lib.mkIf config.custom.grubThemeNixos.enable {
    boot.loader.grub.theme = pkgs.nixos-grub2-theme;
  };
}
