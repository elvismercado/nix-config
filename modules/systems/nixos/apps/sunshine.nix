# Sunshine — self-hosted game/desktop streaming host (Moonlight-compatible)
#
# Enables the Sunshine service with autostart, opens the firewall, and uses
# `userSettings.hostname` as the advertised name (overridable).
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/apps/sunshine.nix ];
#   custom.sysNixSunshine.enable = true;

{
  config,
  pkgs,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.sysNixSunshine.enable = lib.mkEnableOption "Sunshine game/desktop streaming host (Moonlight-compatible) with autostart and firewall rules";
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
