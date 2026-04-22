# Base system packages shared across NixOS and darwin
#
# Usage:
#   imports = [ ../../../modules/systems/shared/packages.nix ];
#   custom.sysPackages.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysPackages.enable = lib.mkEnableOption "enables base system packages";
  };

  config = lib.mkIf config.custom.sysPackages.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
      nano
    ];
  };
}
