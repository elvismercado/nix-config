# NixOS BGRT Plymouth Theme
# Displays the NixOS snowflake logo in place of the UEFI vendor logo.
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/bootloader/plymouth.nix
#     ../../../modules/systems/nixos/bootloader/plymouth-theme-nixos.nix
#   ];
#   custom.plymouth.enable = true;
#   custom.plymouthThemeNixos.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.plymouthThemeNixos.enable = lib.mkEnableOption "enables NixOS BGRT Plymouth theme";
  };

  config = lib.mkIf config.custom.plymouthThemeNixos.enable {
    boot.plymouth = {
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };
  };
}
