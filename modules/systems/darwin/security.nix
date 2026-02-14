# Security — Touch ID for sudo
#
# Enables Touch ID authentication for sudo via PAM.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/security.nix ];
#   custom.security.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.security.enable = lib.mkEnableOption "enables macOS security settings (Touch ID sudo)";
  };

  config = lib.mkIf config.custom.security.enable {
    security.pam.services.sudo_local = {
      enable = true;
      touchIdAuth = true;
    };
  };
}
