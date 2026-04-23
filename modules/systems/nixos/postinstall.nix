# System-level postinstall alias for NixOS
#
# Makes the `postinstall` command available immediately after first boot,
# before home-manager activation has run. The home-manager linux/aliases.nix
# module also defines this alias — the system-level one ensures it works
# on the very first login.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/postinstall.nix ];
#   custom.sysNixPostinstall.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixPostinstall.enable = lib.mkEnableOption "enables system-level postinstall alias";
  };

  config = lib.mkIf config.custom.sysNixPostinstall.enable {
    assertions = [
      {
        assertion =
          builtins.isString userSettings.repoPath
          && userSettings.repoPath != ""
          && !(lib.hasPrefix "/" userSettings.repoPath)
          && !(builtins.elem ".." (lib.splitString "/" userSettings.repoPath));
        message = ''
          custom.sysNixPostinstall: userSettings.repoPath must be a non-empty
          relative path (no leading '/', no '..' segments). Got: "${toString userSettings.repoPath}"
        '';
      }
    ];

    environment.shellAliases = {
      postinstall = "bash ~/${userSettings.repoPath}/scripts/nixos/postinstall.sh";
    };
  };
}
