# Sleek GRUB Theme
# https://github.com/sandesh236/sleek--themes
#
# The banner text is automatically set to the host's hostname from
# user-settings.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub-theme-sleek.nix ];
#   custom.grubThemeSleek.enable = true;
#   custom.grubThemeSleek.style = "dark"; # or "light", "orange", "bigSur"

{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  options = {
    custom.grubThemeSleek.enable = lib.mkEnableOption "enables Sleek GRUB theme";
    custom.grubThemeSleek.style = lib.mkOption {
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

  config = lib.mkIf config.custom.grubThemeSleek.enable {
    boot.loader.grub.theme = pkgs.sleek-grub-theme.override {
      withStyle = config.custom.grubThemeSleek.style;
      withBanner = userSettings.hostname;
    };
  };
}
