{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixAdb.enable = lib.mkEnableOption "enables ADB udev rules and adbusers group";
  };

  config = lib.mkIf config.custom.sysNixAdb.enable {
    programs.adb.enable = true;
  };
}
