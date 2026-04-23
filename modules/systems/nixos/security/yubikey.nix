# YubiKey support
#
# Starts pcscd for CCID/PIV access, installs the YubiKey udev rules, and adds
# the personalization, manager, and OATH (`yubioath-flutter`) tools.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/security/yubikey.nix ];
#   custom.sysNixYubikey.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.sysNixYubikey.enable = lib.mkEnableOption "YubiKey support (pcscd, udev rules, personalization/manager/OATH tools)";
  };

  config = lib.mkIf config.custom.sysNixYubikey.enable {
    # Smart card daemon (needed for YubiKey CCID/PIV)
    services.pcscd.enable = true;

    # udev rules for YubiKey device access
    services.udev.packages = [ pkgs.yubikey-personalization ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization # CLI configuration tool
      yubikey-manager # ykman CLI
      yubioath-flutter # TOTP authenticator GUI
    ];
  };
}
