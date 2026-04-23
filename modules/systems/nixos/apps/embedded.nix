# Embedded development — Arduino IDE and serial device access
#
# Adds the user to the dialout group for serial port access
# (USB-to-serial adapters, Arduino, ESP8266/ESP32).
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/apps/embedded.nix ];
#   custom.sysNixEmbedded.enable = true;

{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixEmbedded.enable = lib.mkEnableOption "enables embedded development tools and serial device access";
  };

  config = lib.mkIf config.custom.sysNixEmbedded.enable {
    environment.systemPackages = [
      pkgs.arduino-ide
    ];

    users.users.${userSettings.username}.extraGroups = [ "dialout" ];
  };
}
