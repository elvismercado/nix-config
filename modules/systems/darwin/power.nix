# Power — macOS sleep and power management
#
# Configures system and display sleep timers via power.sleep.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/power.nix ];
#   custom.sysDarPower.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarPower.enable = lib.mkEnableOption "enables macOS power management settings";
  };

  config = lib.mkIf config.custom.sysDarPower.enable {
    power.sleep.computer = 30;
    power.sleep.display = 5;
    power.sleep.allowSleepByPowerButton = true;
  };
}
