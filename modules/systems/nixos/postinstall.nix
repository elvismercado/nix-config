# System-level postinstall alias for NixOS
#
# Makes the `postinstall` command available immediately after first boot,
# before home-manager activation has run. The home-manager linux/aliases.nix
# module also defines this alias — the system-level one ensures it works
# on the very first login.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/postinstall.nix ];
#   custom.postinstall.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.postinstall.enable = lib.mkEnableOption "enables system-level postinstall alias";
  };

  config = lib.mkIf config.custom.postinstall.enable {
    environment.shellAliases = {
      postinstall = "bash ~/${userSettings.repoPath}/scripts/nixos/postinstall.sh";
    };
  };
}
