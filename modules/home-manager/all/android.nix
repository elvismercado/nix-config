{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmAndroid.enable = lib.mkEnableOption "enables Android tools (adb, fastboot, scrcpy)";
  };

  config = lib.mkIf config.custom.hmAndroid.enable {
    home.packages = with pkgs; [
      android-tools # adb and fastboot
      scrcpy # screen mirroring and control
    ];
  };
}
