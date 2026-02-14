{
  config,
  lib,
  ...
}:

{
  options = {
    custom.gc.enable = lib.mkEnableOption "enables automatic Nix garbage collection";
  };

  config = lib.mkIf config.custom.gc.enable {
    nix.gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    nix.optimise.automatic = true;
  };
}
