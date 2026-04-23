{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysNixAmdGraphics.enable = lib.mkEnableOption "AMD GPU base support (modesetting video driver)";
  };

  config = lib.mkIf config.custom.sysNixAmdGraphics.enable {
    services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

    hardware.graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    hardware.amdgpu.initrd.enable = lib.mkDefault true;
  };
}
