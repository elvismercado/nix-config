# Cross-platform shell aliases — nix workflow, diagnostics
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/aliases.nix ];
#   custom.hmAliases.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.hmAliases.enable = lib.mkEnableOption "enables Home Manager shell aliases";
  };

  config = lib.mkIf config.custom.hmAliases.enable {
    home.shellAliases = {
      ll = "ls -alF";
      verify = "nix-store --verify";
      trustedusers = "nix config show | grep trusted-users";
      checkall = "hostname && trustedusers";

      # Nix workflow aliases
      switchcd = "cd ${config.home.homeDirectory}/${userSettings.repoPath}";
      switchupdate = "cd ${config.home.homeDirectory}/${userSettings.repoPath} && nix flake update";
      switchcheck = "cd ${config.home.homeDirectory}/${userSettings.repoPath} && nix flake check";
    };
  };
}
