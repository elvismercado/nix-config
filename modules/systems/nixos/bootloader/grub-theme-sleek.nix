# Sleek GRUB Theme
# https://github.com/sandesh236/sleek--themes
#
# The banner text is automatically set to the host's hostname from
# user-settings.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub-theme-sleek.nix ];
#   custom.sysNixGrubThemeSleek.enable = true;
#   custom.sysNixGrubThemeSleek.style = "dark"; # or "light", "orange", "bigSur"

{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixGrubThemeSleek.enable = lib.mkEnableOption "Sleek GRUB theme (light/dark/orange/bigSur, banner = hostname)";
    custom.sysNixGrubThemeSleek.style = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
        "orange"
        "bigSur"
      ];
      default = "dark";
      description = "Sleek theme style variant";
    };
  };

  config = lib.mkIf config.custom.sysNixGrubThemeSleek.enable {
    boot.loader.grub.theme = pkgs.sleek-grub-theme.override {
      withStyle = config.custom.sysNixGrubThemeSleek.style;
      withBanner = userSettings.hostname;
    };
  };
}
