# Docker container runtime
#
# Automatically adds the user to the docker group so containers
# can be managed without sudo.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/docker.nix ];
#   custom.sysNixDocker.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixDocker.enable = lib.mkEnableOption "enables Docker container runtime";
  };

  config = lib.mkIf config.custom.sysNixDocker.enable {
    virtualisation.docker.enable = true;

    users.users.${userSettings.username}.extraGroups = [ "docker" ];

    # Docker defaults to iptables; if you use nftables, uncomment:
    # virtualisation.docker.daemon.settings.iptables = false;
  };
}
