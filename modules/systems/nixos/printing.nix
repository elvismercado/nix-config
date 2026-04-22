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
