{
  config,
  lib,
  ...
}:

{
  imports = [
    ../../shared/garbage.nix
  ];

  config = lib.mkIf config.custom.sysGc.enable {
    nix.gc = {
      dates = "Sun 03:15";
      randomizedDelaySec = "2h";
    };

    nix.optimise.randomizedDelaySec = "1h";
  };
}
