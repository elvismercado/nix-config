# Syncthing — continuous file synchronisation daemon
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/syncthing.nix ];
#   custom.hmSyncthing.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmSyncthing.enable = lib.mkEnableOption "enables syncthing";
  };

  config = lib.mkIf config.custom.hmSyncthing.enable {
    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
      overrideDevices = false; # If set to false, devices added via the web interface will persist and will have to be deleted manually.
      overrideFolders = false; # If set to false, folders added via the web interface will persist and will have to be deleted manually.
      settings.options = {
        urAccepted = -1;
        localAnnounceEnabled = true;
      };
    };
  };
}
