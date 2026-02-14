{
  config,
  lib,
  ...
}:

{
  options = {
    custom.logitechMouse.enable = lib.mkEnableOption "enables Logitech wireless mouse support";
  };

  config = lib.mkIf config.custom.logitechMouse.enable {
    # Support for Logitech unifying reciever (Solaar)
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
  };
}
