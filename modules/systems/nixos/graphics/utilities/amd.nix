{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.amdGraphics.enable = lib.mkEnableOption "enables AMD GPU graphics support";
  };

  config = lib.mkIf config.custom.amdGraphics.enable {
    services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    hardware.amdgpu.initrd.enable = lib.mkDefault true;
  };
}
