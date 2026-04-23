# System-level bash completion — shared between NixOS and nix-darwin
#
# Enables `programs.bash.completion` so completion data installed by other
# packages is wired up at the system level.
#
# Usage:
#   imports = [ ../../../modules/systems/shared/bash.nix ];
#   custom.sysBashCompletion.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysBashCompletion.enable = lib.mkEnableOption "system-level bash completion (programs.bash.completion)";
  };

  config = lib.mkIf config.custom.sysBashCompletion.enable {
    programs.bash.completion.enable = true;
  };
}
