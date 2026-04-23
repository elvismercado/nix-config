# CoolerControl — fan and pump control with a daemon + GUI
#
# Pulls in `lm_sensors` for full hardware sensor detection and enables
# the CoolerControl daemon (`programs.coolercontrol`).
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/apps/coolercontrol.nix ];
#   custom.sysNixCoolercontrol.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.sysNixCoolercontrol.enable = lib.mkEnableOption "enables CoolerControl fan control";
  };

  config = lib.mkIf config.custom.sysNixCoolercontrol.enable {
    # Ensure lm_sensors kernel modules are loaded for full hardware sensor detection
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];

    programs.coolercontrol.enable = true;
  };
}
