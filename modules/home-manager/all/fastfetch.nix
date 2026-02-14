# Fastfetch — fast system information tool (neofetch replacement)
# https://github.com/fastfetch-cli/fastfetch
#
# Displays system info on login with a small logo and minimal modules
# for fast startup. Omits: packages, shell, WM, theme, font, terminal.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/fastfetch.nix ];
#   custom.fastfetch.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.fastfetch.enable = lib.mkEnableOption "enables fastfetch system info tool";
  };

  config = lib.mkIf config.custom.fastfetch.enable {
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
