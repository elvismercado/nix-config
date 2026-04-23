# Brave browser — installed via home-manager
#
# Automatically enables KDE Plasma browser integration when
# desktopEnvironment = "kde-plasma" in user-settings.nix.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/brave.nix ];
#   custom.hmBrave.enable = true;

{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.hmBrave.enable = lib.mkEnableOption "Brave browser (with KDE Plasma integration when desktopEnvironment = kde-plasma)";
  };

  config = lib.mkIf config.custom.hmBrave.enable {
    programs.brave = {
      enable = true;

      nativeMessagingHosts = lib.optionals
        ((userSettings.desktopEnvironment or null) == "kde-plasma")
        [ pkgs.kdePackages.plasma-browser-integration ];
    };
  };
}
