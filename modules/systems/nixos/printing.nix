{
  config,
  lib,
  ...
}:

{
  options = {
    custom.printing.enable = lib.mkEnableOption "enables CUPS printing";
  };

  config = lib.mkIf config.custom.printing.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      startWhenNeeded = true;
      stateless = true;
    };
  };
}
