# Shared font packages — installed at the system level on NixOS and nix-darwin
#
# Installs the Nerd Font and Google Fonts collections used across hosts.
# Re-exported by darwin/fonts.nix and nixos/system/fonts.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/shared/fonts.nix ];
#   custom.sysFonts.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysFonts.enable = lib.mkEnableOption "enables shared font packages";
  };

  config = lib.mkIf config.custom.sysFonts.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.departure-mono
      google-fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.commit-mono
    ];
  };
}
