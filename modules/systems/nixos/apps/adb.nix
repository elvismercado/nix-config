{
  config,
  lib,
  ...
}:

{
  options = {
    custom.adb.enable = lib.mkEnableOption "enables ADB udev rules and adbusers group";
  };

  config = lib.mkIf config.custom.adb.enable {
    programs.adb.enable = true;
  };
}
