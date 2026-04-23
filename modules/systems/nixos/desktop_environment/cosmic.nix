# COSMIC desktop environment
#
# Enables the COSMIC desktop manager and cosmic-greeter login manager,
# plus the cosmic.cachix.org binary cache so packages don't have to be
# built from source. Also exports COSMIC_DATA_CONTROL_ENABLED so the
# clipboard manager can talk to cosmic-comp.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/desktop_environment/cosmic.nix ];
#   custom.sysNixCosmicDesktop.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:
  };

  config = lib.mkIf config.custom.sysNixCosmicDesktop.enable {
    # Binary cache for COSMIC packages (avoids building from source)
    nix.settings.extra-substituters = [ "https://cosmic.cachix.org/" ];
    nix.settings.extra-trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];

    # Enable the COSMIC login manager
    services.displayManager.cosmic-greeter.enable = true;

    # Enable the COSMIC desktop environment
    services.desktopManager.cosmic.enable = true;

    # Support for automatic logins is present when using the `cosmic-greeter` login manager. All you need is the following configuration:
    # services.displayManager.autoLogin = {
    #   enable = true;
    #   user = userSettings.username;
    # };

    # COSMIC Utilities - Clipboard Manager not working
    # The zwlr_data_control_manager_v1 protocol needs to be available. Enable it in cosmic-comp via the following configuration:
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    # COSMIC Utilities - Observatory not working
    # The monitord service must be enabled to use
    # NOTE: Observatory repo archived Sep 2025, monitord submodule broken upstream. Re-enable when nixos-cosmic updates.
    # systemd.packages = [ pkgs.observatory ];
    # systemd.services.monitord.wantedBy = [ "multi-user.target" ];

    #  environment.cosmic.excludePackages = with pkgs; [
    #    # cosmic-edit
    #  ];

    # You can slightly improve the performance of your Cosmic installation by enabling system76's own scheduler using this code block inside of your NixOS configuration file:
    services.system76-scheduler.enable = true;

    programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Wayland support in chromium and electron

    # User configuration files are located in ~/.config/cosmic/.
  };
}
