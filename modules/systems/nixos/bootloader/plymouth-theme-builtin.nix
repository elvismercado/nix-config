# Built-in Plymouth Themes
# These ship with the plymouth package — no extra themePackages needed.
#
# Available themes:
#   "bgrt"       — UEFI vendor logo + spinner (Plymouth default)
#   "spinner"    — animated spinner dots with watermark
#   "spinfinity" — infinity-loop throbber with header image
#   "fade-in"    — stars that slowly fade into view
#   "glow"       — pulsing glow animation with progress bar
#   "solar"      — space/solar flare effect with progress bar
#   "script"     — scripted theme with progress bar
#   "tribar"     — three horizontal animated color bars
#   "text"       — pure text output, no graphical splash
#   "details"    — detailed text boot log
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/bootloader/plymouth.nix
#     ../../../modules/systems/nixos/bootloader/plymouth-theme-builtin.nix
#   ];
#   custom.sysNixPlymouth.enable = true;
#   custom.sysNixPlymouthThemeBuiltin.enable = true;
#   custom.sysNixPlymouthThemeBuiltin.theme = "solar";

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixPlymouthThemeBuiltin.enable = lib.mkEnableOption "a built-in Plymouth theme (bgrt, spinner, spinfinity, fade-in, etc.)";

    custom.sysNixPlymouthThemeBuiltin.theme = lib.mkOption {
      type = lib.types.enum [
        "bgrt"
        "spinner"
        "spinfinity"
        "fade-in"
        "glow"
        "solar"
        "script"
        "tribar"
        "text"
        "details"
      ];
      default = "bgrt";
      description = "Built-in Plymouth theme to use";
    };
  };

  config = lib.mkIf config.custom.sysNixPlymouthThemeBuiltin.enable {
    boot.plymouth.theme = config.custom.sysNixPlymouthThemeBuiltin.theme;
  };
}
