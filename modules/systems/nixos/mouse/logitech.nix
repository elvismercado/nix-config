{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixLogitechMouse.enable = lib.mkEnableOption "enables Logitech wireless mouse support";
  };

  config = lib.mkIf config.custom.sysNixLogitechMouse.enable {
    # Support for Logitech unifying reciever (Solaar)
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
  };
}
