{
  config,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.sysNixTimezone.enable = lib.mkEnableOption "enables timezone configuration";
  };

  config = lib.mkIf config.custom.sysNixTimezone.enable {
    time.timeZone = userSettings.timeZone;
  };
}
