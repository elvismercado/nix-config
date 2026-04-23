# Linux-only user packages not managed by a dedicated module
#
# Packages here are only available on Linux (not in nixpkgs for darwin).
# Cross-platform packages belong in all/packages.nix instead.
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/packages.nix ];
#   custom.hmLinuxPackages.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmLinuxPackages.enable = lib.mkEnableOption "enables Linux-only Home Manager packages";
  };

  config = lib.mkIf config.custom.hmLinuxPackages.enable {
    home.packages = with pkgs; [
      cameractrls # Camera controls for Linux
      # cameractrls-gtk3
      # cameractrls-gtk4

      rpi-imager # Raspberry Pi Imaging Utility

      beeper # all chats in one app

      # stuff that should always be in the "systemtray"
      ferdium # browser for always on services
      protonmail-bridge-gui # ProtonMail bridge
      insync # Google Drive, OneDrive, and Dropbox
      # insync-nautilus # gnome
      # insync-emblem-icons # file manager emblem icons for Insync file manager extensions
    ];
  };
}
