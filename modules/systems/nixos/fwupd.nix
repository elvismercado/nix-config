{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixFwupd.enable = lib.mkEnableOption "enables fwupd firmware update daemon";
  };

  config = lib.mkIf config.custom.sysNixFwupd.enable {
    services.fwupd.enable = true;
  };
}
