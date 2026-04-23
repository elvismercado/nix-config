# earlyoom — early out-of-memory daemon
# https://github.com/rfjakob/earlyoom
#
# The default Linux OOM killer triggers too late — by the time it acts
# the system has been unresponsive for minutes, thrashing swap. earlyoom
# monitors available memory and sends SIGTERM to the largest process
# *before* the system locks up.
#
# Particularly useful on desktop systems where a browser tab or
# compilation can unexpectedly consume all RAM.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/memory/earlyoom.nix ];
#   custom.sysNixEarlyoom.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixEarlyoom.enable = lib.mkEnableOption "earlyoom userspace OOM-prevention daemon";
  };

  config = lib.mkIf config.custom.sysNixEarlyoom.enable {
    services.earlyoom = {
      enable = lib.mkDefault true;

      # Trigger when free memory drops below 5%
      freeMemThreshold = lib.mkDefault 5;

      # Trigger when free swap drops below 10%
      freeSwapThreshold = lib.mkDefault 10;

      # Send a desktop notification when earlyoom kills a process,
      # so the user knows what happened.
      enableNotifications = lib.mkDefault true;
    };
  };
}
