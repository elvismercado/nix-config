# Nextcloud desktop client
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/nextcloud.nix ];
#   custom.hmNextcloud.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmNextcloud.enable = lib.mkEnableOption "Nextcloud desktop sync client";
  };

  config = lib.mkIf config.custom.hmNextcloud.enable {
    services.nextcloud-client = {
      enable = true;
    };
  };
}
