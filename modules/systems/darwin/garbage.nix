# Darwin Nix garbage collection — schedules weekly GC via launchd
#
# Re-exports the shared sysGc toggle and adds the macOS-specific schedule
# (Sundays at 03:15). Soft-guarded against Determinate Nix in shared/garbage.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/garbage.nix ];
#   custom.sysGc.enable = true;

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
