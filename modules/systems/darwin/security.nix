# Security — Touch ID for sudo
#
# Enables Touch ID authentication for sudo via PAM.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/security.nix ];
#   custom.sysDarSecurity.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarSecurity.enable = lib.mkEnableOption "enables macOS security settings (Touch ID sudo)";
  };

  config = lib.mkIf config.custom.sysDarSecurity.enable {
    security.pam.services.sudo_local = {
      enable = true;
      touchIdAuth = true;
    };
  };
}
