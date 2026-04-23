# Control Center — macOS menu bar items
#
# Configures which Control Center items are shown in the
# menu bar via system.defaults.controlcenter.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/control-center.nix ];
#   custom.sysDarControlCenter.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarControlCenter.enable = lib.mkEnableOption "macOS Control Center menu bar items (AirDrop, battery %, Bluetooth, etc.)";
  };

  config = lib.mkIf config.custom.sysDarControlCenter.enable {
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
