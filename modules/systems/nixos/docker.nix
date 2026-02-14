{
  config,
  lib,
  ...
}:

{
  options = {
    custom.docker.enable = lib.mkEnableOption "enables Docker container runtime";
  };

  config = lib.mkIf config.custom.docker.enable {
    virtualisation.docker.enable = true;

    # Docker defaults to iptables; if you use nftables, uncomment:
    # virtualisation.docker.daemon.settings.iptables = false;
  };
}
