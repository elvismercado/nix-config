# GRUB bootloader — EFI boot configuration
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/bootloader/grub.nix ];
#   custom.sysNixGrub.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixGrub.enable = lib.mkEnableOption "GRUB EFI bootloader (configurable timeout)";

    custom.sysNixGrub.timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = ''
        Seconds to show the GRUB menu before auto-booting the default entry.
        Set to 0 to boot immediately (hold Shift to force menu).
      '';
    };

    custom.sysNixGrub.gfxmodeEfi = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = ''
        GRUB EFI graphics mode. Use a comma-separated fallback chain
        for multi-monitor setups, e.g. "2560x1440,auto".
        "auto" lets GRUB pick the best available mode.
      '';
    };
  };

  config = lib.mkIf config.custom.sysNixGrub.enable {
    boot.loader = {
      timeout = config.custom.sysNixGrub.timeout;
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 20;

        # Resolution — use the host-configured mode for a crisp boot menu.
        # "keep" passes the resolution to the kernel, so the console and
        # Plymouth inherit it without a mode switch.
        # Set custom.sysNixGrub.gfxmodeEfi per host (e.g. "2560x1440,auto").
        gfxmodeEfi = config.custom.sysNixGrub.gfxmodeEfi;
        gfxpayloadEfi = "keep";

        # OS prober — auto-detect other OSes (Windows, other Linux) on disk
        # and add them as GRUB menu entries. NixOS includes the os-prober
        # package automatically.
        useOSProber = true;

        # Memtest86+ — memory diagnostic tool in the boot menu.
        # Reboot and select "Memtest86+" from the GRUB menu to test RAM.
        memtest86.enable = true;
      };
    };
  };
}
