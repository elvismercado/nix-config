{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmPackages.enable = lib.mkEnableOption "enables Home Manager packages";
  };

  config = lib.mkIf config.custom.hmPackages.enable {
    home.packages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      localsend

      mullvad-vpn # Client for Mullvad VPN
      mullvad-closest # Find Mullvad servers with the lowest latency at your location
      # mullvad-browser # Privacy-focused browser made in a collaboration between The Tor Project and Mullvad

      handbrake # Tool for converting video files and ripping DVDs

      # sweethome3d.application # find the rest of the things needed

      cameractrls # Camera controls for Linux
      # cameractrls-gtk3
      # cameractrls-gtk4

      headsetcontrol # Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)
      # headsetcontrol-notificationd
      # HeadsetControl-Qt

      rpi-imager # Raspberry Pi Imaging Utility

      moonlight-qt # Open source game streaming client

      mpv

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
