# Android development & device tools — installed via home-manager
#
# Provides adb/fastboot for device interaction and scrcpy for screen mirroring.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/android.nix ];
#   custom.hmAndroid.enable = true;

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
