{
  config,
  pkgs,
  lib,
  userSettings, # from user-settings.nix
  ...
}:

{
  options = {
    custom.sunshine.enable = lib.mkEnableOption "enables sunshine";
  };

  config = lib.mkIf config.custom.sunshine.enable {
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
      # applications = {
      #   env = {
      #     PATH = "$(PATH):$(HOME)/.local/bin";
      #   };
      #   apps = [
      #     {
      #       name = "1440p Desktop";
      #       prep-cmd = [
      #         {
      #           do = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
      #           undo = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
      #         }
      #       ];
      #       exclude-global-prep-cmd = "false";
      #       auto-detach = "true";
      #     }
      #   ];
      # };
    };
  };
}
