# SSH Server module — enables inbound SSH access (services.openssh).
# This does NOT affect the SSH client, which is available by default.
# Import and enable this only on hosts that should accept incoming SSH connections.
#
# Secure by default:
#   - Password auth disabled (key-only). Override with custom.sshServer.passwordAuth = true.
#   - AllowUsers restricted to userSettings.username. All other users are denied SSH access.
#
# Usage:
#   imports = [ ../../../modules/systems/shared/ssh-server.nix ];
#   custom.sshServer.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sshServer.enable = lib.mkEnableOption "enables OpenSSH server for inbound SSH access";
    custom.sshServer.passwordAuth = lib.mkEnableOption "allow SSH password authentication (less secure than key-only)";
  };

  config = lib.mkIf config.custom.sshServer.enable {
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = config.custom.sshServer.passwordAuth;
        AllowUsers = [ userSettings.username ];
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  };
}
