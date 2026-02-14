# Bluetooth — enables Bluetooth hardware support
#
# Provides wireless connectivity for peripherals, headphones, and speakers.
# Audio profiles (A2DP) are managed by PipeWire/WirePlumber, not BlueZ.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bluetooth.nix ];
#   custom.bluetooth.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.bluetooth.enable = lib.mkEnableOption "enables Bluetooth support with A2DP audio";
  };

  config = lib.mkIf config.custom.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
  };
}
