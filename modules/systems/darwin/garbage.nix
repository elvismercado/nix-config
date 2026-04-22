{
  config,
  lib,
  ...
}:

{
  imports = [
    ../shared/garbage.nix
  ];

  config = lib.mkIf config.custom.sysGc.enable {
    nix.gc = {
      interval = [
        {
          Hour = 3;
          Minute = 15;
          Weekday = 7;
        }
      ];
    };
  };
}
