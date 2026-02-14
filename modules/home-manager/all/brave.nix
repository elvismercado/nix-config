{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.brave.enable = lib.mkEnableOption "enables brave";
  };

  config = lib.mkIf config.custom.brave.enable {
    programs.brave = {
      enable = true;

      nativeMessagingHosts = [
        # pkgs.kdePackages.plasma-browser-integration # only on kde
      ];
    };
  };
}
