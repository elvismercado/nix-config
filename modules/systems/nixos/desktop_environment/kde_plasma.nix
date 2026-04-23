# KDE Plasma 6 — desktop environment
#
# Enables Plasma 6 with the Wayland session as the SDDM default, trims unused
# KDE apps (Discover, Elisa, KHelpCenter, Kate), and installs the browser /
# system integration packages.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/desktop_environment/kde_plasma.nix ];
#   custom.sysNixKdePlasma.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysNixKdePlasma.enable = lib.mkEnableOption "enables KDE Plasma desktop environment";
  };

  config = lib.mkIf config.custom.sysNixKdePlasma.enable {
    # Enable the KDE Plasma Desktop Environment.
    # Note: wayland.enable is set in sddm.nix — not duplicated here.
    services.displayManager.defaultSession = "plasma"; # "plasma" "plasmax11"

    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover # Software center — Flatpak not used
      elisa # Music player
      khelpcenter # Help Centre
      kate # Text editor — using VS Code (also removes KWrite)
      # powerdevil # no need to check powerconsumption on pc
      # upower
      # power-profiles-daemon
    ];

    #   environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Wayland support in chromium and electron

    # List packages installed in system profile. (all users)
    environment.systemPackages = with pkgs; [
      kdePackages.plasma-browser-integration
      kdePackages.plasma-integration
    ];
  };
}
