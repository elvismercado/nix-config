# Linux-only shell aliases
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/aliases.nix ];
#   custom.hmLinuxAliases.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmLinuxAliases.enable = lib.mkEnableOption "enables Linux-specific shell aliases";
  };

  config = lib.mkIf config.custom.hmLinuxAliases.enable {
    home.shellAliases = {
      postinstall = "bash ${config.home.homeDirectory}/git/nix-config/scripts/nixos/postinstall.sh";
    };
  };
}
