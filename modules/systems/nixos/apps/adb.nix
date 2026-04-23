# Android Debug Bridge (ADB) — udev rules and adbusers group
#
# Automatically adds the user to the adbusers group.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/apps/adb.nix ];
#   custom.sysNixAdb.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixAdb.enable = lib.mkEnableOption "Android Debug Bridge (adb udev rules + adbusers group membership)";
  };

  config = lib.mkIf config.custom.sysNixAdb.enable {
    programs.adb.enable = true;

    users.users.${userSettings.username}.extraGroups = [ "adbusers" ];
  };
}
