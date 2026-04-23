# Linux-only user packages not managed by a dedicated module
#
# GUI apps that use Homebrew casks on macOS belong here (not in all/packages.nix).
# Cross-platform CLI tools belong in all/packages.nix instead.
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
      localsend
      mullvad-vpn # Client for Mullvad VPN
      moonlight-qt # Open source game streaming client

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
