# Generic nomodeset fallback — boots any GPU with the EFI/VESA framebuffer
#
# Use this when no GPU-specific module is available or when debugging
# graphics issues. Disables kernel mode-setting so the system falls back
# to the EFI framebuffer. Provides basic 2D display only (no 3D, no Vulkan).
#
# Because nomodeset disables KMS, Wayland compositors cannot run. Pair
# this with the x11-fallback display manager module if your desktop
# environment defaults to Wayland (e.g. KDE Plasma 6):
#   imports = [ ../../../modules/systems/nixos/display_manager/x11-fallback.nix ];
#   custom.x11Fallback.enable = true;
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/graphics/nomodeset.nix ];
#   custom.nomodeset.enable = true;
#
# Optional: override the EFI framebuffer mode if auto-detection picks
# a wrong resolution:
#   custom.nomodeset.efifbMode = "1920x1080-32@60";
#
# Emergency GRUB override (no rebuild needed):
#   At the GRUB menu, press 'e' to edit the boot entry, append 'nomodeset'
#   to the 'linux' line, then press Ctrl+X to boot. This is temporary —
#   gone on next reboot. For a persistent fix, enable this module and rebuild.

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.nomodeset.enable = lib.mkEnableOption "enables nomodeset (basic framebuffer driver)";

    custom.nomodeset.efifbMode = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "1920x1080-32@60";
      description = "Optional EFI framebuffer mode (resolution-depth@refresh). Leave null for auto-detection.";
    };
  };

  config = lib.mkIf config.custom.nomodeset.enable {

    # Disable all GPU kernel mode-setting — forces EFI/VESA framebuffer
    boot.kernelParams = [ "nomodeset" ]
      ++ lib.optionals (config.custom.nomodeset.efifbMode != null) [
        "video=efifb:${config.custom.nomodeset.efifbMode}"
      ];

    # Use the generic modesetting DDX (falls back to fbdev with nomodeset)
    services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

    # Mesa — needed for desktop environments even on a framebuffer
    hardware.graphics.enable = lib.mkDefault true;
  };
}
