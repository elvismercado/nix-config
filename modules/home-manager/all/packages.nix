# Additional cross-platform user packages not managed by a dedicated module
#
# GUI apps that need Homebrew on macOS belong in linux/packages.nix instead.
# Cross-platform CLI tools belong here.
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
      cowsay
      lolcat

      mullvad-closest # Find Mullvad servers with the lowest latency at your location

      headsetcontrol # Sidetone and Battery status for Logitech G930, G533, G633, G933 SteelSeries Arctis 7/PRO 2019 and Corsair VOID (Pro)
      # headsetcontrol-notificationd
      # HeadsetControl-Qt
    ];
  };
}
