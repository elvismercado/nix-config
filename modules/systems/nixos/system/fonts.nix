# NixOS-specific font config
#
# Imports shared/fonts.nix (the cross-platform font package set) and
# adds NixOS-only settings: enableDefaultPackages and a fontconfig
# default-font block so SDDM, the console, and all user sessions pick
# up consistent serif/sans/mono families.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/system/fonts.nix ];
#   custom.sysFonts.enable = true;

{
  config,
  lib,
  ...
}:

{
  imports = [
    ../../shared/fonts.nix
  ];

  config = lib.mkIf config.custom.sysFonts.enable {
    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        defaultFonts = {
          serif = [
            "Source Code Pro"
            "Diphylleia"
            "serif"
          ];
          sansSerif = [
            "Source Code Pro"
            "Klee One"
            "sans-serif"
          ];
          monospace = [
            "CommitMono"
            "LXGW WenKai Mono TC"
            "Departure Mono"
            "monospace"
          ];
        };
      };
    };
  };
}
