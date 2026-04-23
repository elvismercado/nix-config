# Logitech wireless mouse / Unifying receiver support
#
# Enables `hardware.logitech.wireless` (with the graphical Solaar manager) so
# Unifying receivers and Logitech wireless devices are recognised and pairable.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/mouse/logitech.nix ];
#   custom.sysNixLogitechMouse.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixLogitechMouse.enable = lib.mkEnableOption "Logitech wireless mouse / Unifying receiver support (with Solaar)";
  };

  config = lib.mkIf config.custom.sysNixLogitechMouse.enable {
    # Support for Logitech unifying reciever (Solaar)
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;
  };
}
