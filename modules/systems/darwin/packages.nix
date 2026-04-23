# Darwin shared packages wrapper — re-exports the shared package set
#
# Toggle is provided by ../shared/packages.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/packages.nix ];
#   custom.sysPackages.enable = true;

{
  imports = [
    ../shared/packages.nix
  ];
}
