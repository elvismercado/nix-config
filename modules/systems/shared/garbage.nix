# Automatic Nix garbage collection and store optimisation
#
# Usage:
#   imports = [ ../../../modules/systems/shared/garbage.nix ];
#   custom.sysGc.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysGc.enable = lib.mkEnableOption "enables automatic Nix garbage collection";
  };

  config = lib.mkIf config.custom.sysGc.enable {
    nix.gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    nix.optimise.automatic = true;
  };
}
