# CUPS printing — enables the CUPS daemon for network/USB printers
#
# Daemon is socket-activated (startWhenNeeded) and runs stateless so it picks
# up configuration purely from the Nix store.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/printing.nix ];
#   custom.sysNixPrinting.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixPrinting.enable = lib.mkEnableOption "enables CUPS printing";
  };

  config = lib.mkIf config.custom.sysNixPrinting.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      startWhenNeeded = true;
      stateless = true;
    };
  };
}
