{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixWacom.enable = lib.mkEnableOption "enables Wacom tablet support";
  };

  config = lib.mkIf config.custom.sysNixWacom.enable {
    # Wacom kernel driver and input handling
    services.xserver.wacom.enable = true;

    # libinput handles Wacom devices on Wayland
    # xserver.wacom is still needed for X11 and some configuration tools
  };
}
