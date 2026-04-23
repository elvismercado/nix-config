{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixSystemdBoot.enable = lib.mkEnableOption "systemd-boot EFI bootloader";
  };

  config = lib.mkIf config.custom.sysNixSystemdBoot.enable {
    boot.loader = {
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 20;

        # Memtest86+ — memory diagnostic tool in the boot menu.
        memtest86.enable = true;
      };
    };
  };
}
