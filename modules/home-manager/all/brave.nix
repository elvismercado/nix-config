# Brave browser — installed via home-manager with optional extensions
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/brave.nix ];
#   custom.hmBrave.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmBrave.enable = lib.mkEnableOption "enables brave";
  };

  config = lib.mkIf config.custom.hmBrave.enable {
    programs.brave = {
      enable = true;

      nativeMessagingHosts = [
        # pkgs.kdePackages.plasma-browser-integration # only on kde
      ];
    };
  };
}
