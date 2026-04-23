# Timezone configuration
#
# Sets time.timeZone from userSettings.timeZone so the host clock and
# log timestamps match the location configured in user-settings.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/system/time.nix ];
#   custom.sysNixTimezone.enable = true;

{
  config,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.sysNixTimezone.enable = lib.mkEnableOption "timezone configuration from userSettings.timeZone";
  };

  config = lib.mkIf config.custom.sysNixTimezone.enable {
    time.timeZone = userSettings.timeZone;
  };
}
