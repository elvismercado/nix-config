{
  config,
  pkgs,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.sysNixSunshine.enable = lib.mkEnableOption "enables sunshine";
  };

  config = lib.mkIf config.custom.sysNixSunshine.enable {
    environment.systemPackages = with pkgs; [
      sunshine
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        sunshine_name = lib.mkDefault userSettings.hostname;
      };
    };
  };
}
