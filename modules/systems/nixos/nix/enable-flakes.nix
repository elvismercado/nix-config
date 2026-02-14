# Enable Flakes
# nix.settings.experimental-features = [ "nix-command" "flakes" ];
# Other Distros, without Home-Manager
# Note: The Determinate Nix Installer enables flakes by default.
# Add the following to ~/.config/nix/nix.conf or /etc/nix/nix.conf:
# experimental-features = nix-command flakes

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.enableFlakes.enable = lib.mkEnableOption "enables Nix flakes and nix-command";
  };

  config = lib.mkIf config.custom.enableFlakes.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
  };
}
