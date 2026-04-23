# Nix flakes — enables the `nix-command` and `flakes` experimental features
#
# Only needed on stock NixOS. The Determinate Nix Installer enables flakes by
# default, so hosts using it (and setting `nix.enable = false`) should leave
# this module disabled.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/nix/enable-flakes.nix ];
#   custom.sysNixEnableFlakes.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixEnableFlakes.enable = lib.mkEnableOption "the `nix-command` and `flakes` experimental features (stock NixOS only — Determinate Nix already enables them)";
  };

  config = lib.mkIf config.custom.sysNixEnableFlakes.enable {
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
