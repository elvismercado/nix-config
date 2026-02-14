{
  config,
  lib,
  ...
}:

{
  options = {
    custom.wacom.enable = lib.mkEnableOption "enables Wacom tablet support";
  };

  config = lib.mkIf config.custom.wacom.enable {
    # Wacom kernel driver and input handling
    services.xserver.wacom.enable = true;

    # libinput handles Wacom devices on Wayland
    # xserver.wacom is still needed for X11 and some configuration tools
  };
}
