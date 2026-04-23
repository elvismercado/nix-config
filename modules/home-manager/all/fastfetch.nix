# Fastfetch — fast system information tool (neofetch replacement)
# https://github.com/fastfetch-cli/fastfetch
#
# Displays system info on login with a small logo and minimal modules
# for fast startup. Omits: packages, shell, WM, theme, font, terminal.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/fastfetch.nix ];
#   custom.hmFastfetch.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.hmFastfetch.enable = lib.mkEnableOption "Fastfetch system info on login (small logo, minimal modules)";
  };

  config = lib.mkIf config.custom.hmFastfetch.enable {
    home.packages = [ pkgs.fastfetch ];

    xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
      logo = {
        type = "small";
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
        "locale"
      ];
    };
  };
}
