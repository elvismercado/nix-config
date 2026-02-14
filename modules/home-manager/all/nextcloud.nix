{
  config,
  lib,
  ...
}:

{
  options = {
    custom.nextcloud.enable = lib.mkEnableOption "enables nextcloud";
  };

  config = lib.mkIf config.custom.nextcloud.enable {
    services.nextcloud-client = {
      enable = true;
      # startInBackground = true;
    };
  };
}
