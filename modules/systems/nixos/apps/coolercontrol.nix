{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.coolercontrol.enable = lib.mkEnableOption "enables CoolerControl fan control";
  };

  config = lib.mkIf config.custom.coolercontrol.enable {
    # Ensure lm_sensors kernel modules are loaded for full hardware sensor detection
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];

    programs.coolercontrol.enable = true;
  };
}
