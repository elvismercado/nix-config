# NixOS-specific layer over shared/garbage.nix
#
# Imports the shared module (which exposes custom.sysGc.enable) and adds
# NixOS-only nix.gc scheduling: weekly run on Sunday 03:15 with up to 2h
# random delay, plus a 1h random delay for nix.optimise.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/nix/garbage.nix ];
#   custom.sysGc.enable = true;

{
  config,
  lib,
  ...
}:
    nix.gc = {
      dates = "Sun 03:15";
      randomizedDelaySec = "2h";
    };

    nix.optimise.randomizedDelaySec = "1h";
  };
}
