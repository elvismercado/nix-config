{
  config,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.timezone.enable = lib.mkEnableOption "enables timezone configuration";
  };

  config = lib.mkIf config.custom.timezone.enable {
    time.timeZone = userSettings.timeZone;
  };
}
