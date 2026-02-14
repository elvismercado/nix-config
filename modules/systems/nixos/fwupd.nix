{
  config,
  lib,
  ...
}:

{
  options = {
    custom.fwupd.enable = lib.mkEnableOption "enables fwupd firmware update daemon";
  };

  config = lib.mkIf config.custom.fwupd.enable {
    services.fwupd.enable = true;
  };
}
