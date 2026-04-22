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
