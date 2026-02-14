# SSH Server module — enables inbound SSH access (services.openssh).
# This does NOT affect the SSH client, which is available by default.
# Import and enable this only on hosts that should accept incoming SSH connections.

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sshServer.enable = lib.mkEnableOption "enables OpenSSH server for inbound SSH access";
  };

  config = lib.mkIf config.custom.sshServer.enable {
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  };
}
