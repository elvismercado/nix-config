# NixOS GRUB Theme
# Default NixOS-branded GRUB theme from nixpkgs.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub-theme-nixos.nix ];
#   custom.sysNixGrubThemeNixos.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.sysNixGrubThemeNixos.enable = lib.mkEnableOption "NixOS-branded GRUB theme (from nixpkgs)";
  };

  config = lib.mkIf config.custom.sysNixGrubThemeNixos.enable {
    boot.loader.grub.theme = pkgs.nixos-grub2-theme;
  };
}
