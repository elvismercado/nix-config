# HP AMD Radeon R7 430 LP 2DP PCIe x16 GF
# GPU: Oland (GCN 1.0 / Southern Islands)
# PCI ID: 1002:6611
# Driver: amdgpu (with experimental SI support flag)
#
# Capabilities:
#   - OpenGL 4.x (radeonsi)
#   - Vulkan 1.3 (RADV via Mesa)
#   - VA-API hardware video decode: H.264, MPEG-2, VC-1 (UVD)
#   - Display: 2× DisplayPort 1.2 (max 4K@60 Hz)
#
# Limitations:
#   - No OpenCL / ROCm (kfd does not support SI/Oland)
#   - HDMI absent on this SKU (2× DP only)
#   - No HEVC/VP9 hardware decode (UVD 3.0 predates HEVC)
#   - No VRR / FreeSync (requires GCN 2.0+ / Polaris or newer)
#   - No HDR (requires RDNA / GCN 5.0+ and DP 1.4+)
#   - No 10-bit color output (hardware limitation)
#   - DP 1.2 only — max 4K@60Hz single-link, no DSC
#
# Use cases: desktop / general, video playback

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./utilities/amd.nix ];

  options = {
    custom.sysNixAmdRadeonR7430.enable = lib.mkEnableOption "AMD Radeon R7 430 (Oland/SI) with amdgpu driver and early KMS";
  };

  config = lib.mkIf config.custom.sysNixAmdRadeonR7430.enable {
    # Auto-enable base AMD graphics support
    custom.sysNixAmdGraphics.enable = true;
    # Early KMS start — load amdgpu in initrd for flicker-free boot
    boot.initrd.kernelModules = [ "amdgpu" ];

    # Southern Islands (SI) only — hand off from radeon to amdgpu.
    # CIK params are omitted because this card is SI, not CIK.
    boot.kernelParams = [
      "radeon.si_support=0" # prevent radeon from claiming SI GPUs
      "amdgpu.si_support=1" # let amdgpu drive SI GPUs (experimental)
    ];

    # Includes linux-firmware (amdgpu firmware blobs for Oland)
    hardware.enableAllFirmware = true;

    # NixOS 25.05+ amdgpu initrd integration
    hardware.amdgpu.initrd.enable = true;

    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa # OpenGL (radeonsi) + Vulkan (RADV) — RADV is built into Mesa
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        mesa # 32-bit OpenGL + Vulkan (Wine/Proton games)
      ];
    };

    # nvtop with AMD support — inline (no separate module needed)
    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];

    environment.sessionVariables = {
      # Qt Quick rendering via RHI — picks Vulkan (RADV) or falls back to
      # OpenGL (radeonsi), avoiding legacy scenegraph paths that can break
      # on older GCN hardware. Without this, KDE Plasma 6 may fail with
      # "Could not load QML component".
      QT_QUICK_BACKEND = "rhi";

      # SDL_VIDEODRIVER: not set — modern SDL2/SDL3 auto-detect Wayland.
      # Forcing "wayland" breaks Easy Anti-Cheat games under Proton (Elden Ring, etc.)
      # SDL_VIDEODRIVER = "wayland";

      # Force Firefox/Mozilla apps to use the Wayland backend
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}

# Verification commands:
# nix-shell -p pciutils --run "lspci -nn | grep -i vga"
# sudo dmesg | grep -iE 'amdgpu|radeon|drm'
# nix-shell -p glxinfo --run "glxinfo | grep 'OpenGL renderer'"
# nix-shell -p vulkan-tools --run "vulkaninfo --summary"
# nix-shell -p vulkan-tools --run "vulkaninfo | grep deviceName"
# nix-shell -p libva-utils --run "vainfo"

# Known quirks & solutions:
#
# Quirk: "amdgpu: dpm is not supported on this asic" in dmesg
#   → Harmless — Oland's power management is basic; the card runs fine without DPM.
#
# Quirk: kfd warning "not supported on this asic" in dmesg
#   → Expected — SI/Oland does not support kfd (OpenCL/ROCm compute).
#     No action needed; the warning is cosmetic.
#
# Quirk: Screen tearing on Wayland/X11
#   → KDE: System Settings → Display → Compositor → set "Rendering backend" to OpenGL 3.1.
#     Sway/Hyprland: tearing is usually absent; if present, try:
#       environment.sessionVariables.KWIN_DRM_NO_AMS = "1";
#
# Quirk: amdgpu fails to load, falls back to radeon
#   → Verify kernel params are applied: cat /proc/cmdline
#     Must contain: radeon.si_support=0 amdgpu.si_support=1
#     If radeon loads first, ensure boot.initrd.kernelModules includes "amdgpu".
#
# Quirk: Graphical artifacts or corruption after resume from suspend
#   → Try adding "amdgpu.runpm=0" to boot.kernelParams to disable runtime PM.
#     Alternatively, update to the latest linux-firmware.
#
# Quirk: Firmware loading warnings at boot
#   → Ensure hardware.enableAllFirmware = true. The Oland firmware blobs
#     (oland_ce.bin, oland_mc.bin, etc.) are in linux-firmware.
