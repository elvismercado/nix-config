# Automatic Nix garbage collection and store optimisation
#
# On Determinate Nix hosts (nix.enable = false), GC and optimisation
# are managed by the Determinate installer. This module auto-disables
# in that case — enabling custom.sysGc has no effect.
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

  config = lib.mkIf (config.custom.sysGc.enable && config.nix.enable) {
    nix.gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    nix.optimise.automatic = true;
  };
}
