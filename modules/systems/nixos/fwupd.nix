# fwupd — firmware update daemon
#
# Enables `services.fwupd` so `fwupdmgr` can fetch and apply UEFI/device
# firmware updates from the Linux Vendor Firmware Service (LVFS).
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/fwupd.nix ];
#   custom.sysNixFwupd.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixFwupd.enable = lib.mkEnableOption "fwupd firmware update daemon (LVFS via fwupdmgr)";
  };

  config = lib.mkIf config.custom.sysNixFwupd.enable {
    services.fwupd.enable = true;
  };
}
