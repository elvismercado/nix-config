{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.android.enable = lib.mkEnableOption "enables Android tools (adb, fastboot, scrcpy)";
  };

  config = lib.mkIf config.custom.android.enable {
    home.packages = with pkgs; [
      android-tools # adb and fastboot
      scrcpy # screen mirroring and control
    ];
  };
}
