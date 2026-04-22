# NixOS-specific font config: imports shared font packages,
# adds enableDefaultPackages and fontconfig defaults (for SDDM, console, all-user access).

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
