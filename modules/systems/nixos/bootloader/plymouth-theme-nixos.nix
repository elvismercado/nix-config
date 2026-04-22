# NixOS BGRT Plymouth Theme
# Displays the NixOS snowflake logo in place of the UEFI vendor logo.
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/bootloader/plymouth.nix
#     ../../../modules/systems/nixos/bootloader/plymouth-theme-nixos.nix
#   ];
#   custom.sysNixPlymouth.enable = true;
#   custom.sysNixPlymouthThemeNixos.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.sysNixPlymouthThemeNixos.enable = lib.mkEnableOption "enables NixOS BGRT Plymouth theme";
  };

  config = lib.mkIf config.custom.sysNixPlymouthThemeNixos.enable {
    boot.plymouth = {
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };
  };
}
