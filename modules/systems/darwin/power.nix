# Power — macOS sleep and power management
#
# Configures system and display sleep timers via power.sleep.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/power.nix ];
#   custom.power.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.power.enable = lib.mkEnableOption "enables macOS power management settings";
  };

  config = lib.mkIf config.custom.power.enable {
    power.sleep.computer = 30;
    power.sleep.display = 5;
    power.sleep.allowSleepByPowerButton = true;
  };
}
