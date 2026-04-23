# Additional cross-platform user packages not managed by a dedicated module
#
# Linux-only packages belong in linux/packages.nix instead.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/packages.nix ];
#   custom.hmPackages.enable = true;

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

      headsetcontrol # Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)
      # headsetcontrol-notificationd
      # HeadsetControl-Qt

      moonlight-qt # Open source game streaming client
    ];
  };
}
