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
    custom.sysPackages.enable = lib.mkEnableOption "base system packages shared across NixOS and darwin (git, gh, nano)";
  };

  config = lib.mkIf config.custom.sysPackages.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
      nano
    ];
  };
}
