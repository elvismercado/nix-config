# Darwin fonts wrapper — re-exports the shared font module
#
# Toggle is provided by ../shared/fonts.nix.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/fonts.nix ];
#   custom.sysFonts.enable = true;

{
  imports = [
    ../shared/fonts.nix
  ];
}
