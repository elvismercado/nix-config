{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.yubikey.enable = lib.mkEnableOption "enables YubiKey support";
  };

  config = lib.mkIf config.custom.yubikey.enable {
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
