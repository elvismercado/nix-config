# Ly — lightweight TUI display manager
# https://github.com/fairyglade/ly
#
# A minimal terminal-based login manager. Renders a clean text UI on a
# virtual terminal — no compositor, no GPU init, near-instant startup.
# Auto-detects Wayland and X11 sessions from .desktop files installed
# by desktop environment modules (e.g. kde_plasma.nix installs plasma.desktop).
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/display_manager/ly.nix
#     ../../../modules/systems/nixos/desktop_environment/kde_plasma.nix
#   ];
#   custom.sysNixLy.enable = true;
#   custom.sysNixKdePlasma.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixLy.enable = lib.mkEnableOption "enables Ly TUI display manager";
  };

  config = lib.mkIf config.custom.sysNixLy.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix"; # matrix animation on the login screen
        numlock = "on";
        waylandsessions = "/run/current-system/sw/share/wayland-sessions";
        xsessions = "/run/current-system/sw/share/xsessions";
      };
    };
  };
}
