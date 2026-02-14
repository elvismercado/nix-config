# Control Center — macOS menu bar items
#
# Configures which Control Center items are shown in the
# menu bar via system.defaults.controlcenter.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/control-center.nix ];
#   custom.controlCenter.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.controlCenter.enable = lib.mkEnableOption "enables macOS Control Center menu bar items";
  };

  config = lib.mkIf config.custom.controlCenter.enable {
    system.defaults.controlcenter = {
      AirDrop = true;
      BatteryShowPercentage = true;
      Bluetooth = true;
      Display = true;
      FocusModes = false;
      NowPlaying = true;
      Sound = true;
    };
  };
}
