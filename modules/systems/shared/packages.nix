# Base system packages shared across NixOS and darwin
#
# Usage:
#   imports = [ ../../../modules/systems/shared/packages.nix ];
#   custom.systemPackages.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.systemPackages.enable = lib.mkEnableOption "enables base system packages";
  };

  config = lib.mkIf config.custom.systemPackages.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
      nano
    ];
  };
}
