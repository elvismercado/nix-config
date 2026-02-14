{ ... }:

{
  imports = [
    # Host
    ./hardware-configuration.nix
    ./configuration.nix
    ./user.nix

    # Nix
    ../../../modules/systems/nixos/nix/enable-flakes.nix
    ../../../modules/systems/nixos/nix/garbage.nix

    # Bootloader
    ../../../modules/systems/nixos/bootloader/grub.nix
    ../../../modules/systems/nixos/bootloader/grub-theme-sleek.nix
    ../../../modules/systems/nixos/bootloader/plymouth.nix
    ../../../modules/systems/nixos/bootloader/plymouth-theme-adi1090x.nix

    # Hardware
    ../../../modules/systems/nixos/cpu/amd/ryzen_9_3900x.nix
    # ../../../modules/systems/nixos/graphics/utilities/nomodeset.nix
    ../../../modules/systems/nixos/graphics/amd_radeon_r7_430.nix
    # ../../../modules/systems/nixos/graphics/nvidia_gtx_1060.nix    # Gigabyte AORUS GTX 1060 6G 9Gbps — uncomment & swap to use
    # ../../../modules/systems/nixos/graphics/nvidia_rtx_3070_lhr.nix # Lenovo MSI RTX 3070 8G LHR — uncomment & swap to use
    ../../../modules/systems/nixos/ssd

    # Memory
    ../../../modules/systems/nixos/memory/zram.nix
    ../../../modules/systems/nixos/memory/earlyoom.nix
    ../../../modules/systems/nixos/memory/hibernation.nix

    # System
    ../../../modules/systems/nixos/packages.nix
    ../../../modules/systems/shared/bash.nix
    ../../../modules/systems/nixos/system/console.nix
    ../../../modules/systems/nixos/system/time.nix
    ../../../modules/systems/nixos/system/i18n.nix
    ../../../modules/systems/nixos/system/fonts.nix
    ../../../modules/systems/nixos/system/network-tuning.nix

    # Display
    # ../../../modules/systems/nixos/display_manager/ly.nix
    # ../../../modules/systems/nixos/display_manager/greetd.nix
    ../../../modules/systems/nixos/display_manager/sddm.nix
    ../../../modules/systems/nixos/display_manager/sddm-monitor-layout.nix
    ../../../modules/systems/nixos/display_manager/sddm-input-config.nix
    ../../../modules/systems/nixos/desktop_environment/kde_plasma.nix

    # Input
    ../../../modules/systems/nixos/mouse/logitech.nix
    ../../../modules/systems/nixos/input/wacom.nix

    # Peripherals
    ../../../modules/systems/nixos/bluetooth.nix
    ../../../modules/systems/nixos/pipewire.nix

    # Security
    ../../../modules/systems/nixos/security/yubikey.nix
    ../../../modules/systems/nixos/security/fprintd.nix

    # Services
    ../../../modules/systems/nixos/printing.nix
    ../../../modules/systems/nixos/fwupd.nix
    ../../../modules/systems/nixos/docker.nix
    ../../../modules/systems/nixos/mullvad.nix
    ../../../modules/systems/nixos/postinstall.nix

    # Apps
    ../../../modules/systems/nixos/apps/adb.nix
    ../../../modules/systems/nixos/apps/libvirtd.nix
    ../../../modules/systems/nixos/apps/coolercontrol.nix
  ];

  # Host
  # (no host-level toggles)

  # Nix
  custom.enableFlakes.enable = true;
  custom.gc.enable = true;

  # Bootloader
  custom.grub.enable = true;
  custom.grub.timeout = 1;
  # custom.grub.gfxmodeEfi = "3840x2160,2560x1440,1920x1080,auto"; # 4K preferred, 1440p fallback, 1080p fallback, auto last resort
  custom.grub.gfxmodeEfi = "1920x1080,auto"; # 4K preferred, 1440p fallback, 1080p fallback, auto last resort
  custom.grubThemeSleek.enable = true;
  custom.grubThemeSleek.style = "dark";
  custom.plymouth.enable = true;
  custom.plymouth.bootDisabledOutputs = [ "DP-2" ]; # auto-adds video=DP-2:d, re-enables before display manager
  custom.plymouth.useSimpleDrm = false; # disable SimpleDRM — amdgpu forced-SI ignores video=DP-2:d either way
  custom.plymouth.minAnimationDuration = 3; # NVMe boots fast — ensure animation plays
  custom.plymouth.minShutdownDuration = 3; # NVMe shuts down fast — ensure splash is visible
  # custom.plymouth.debug = true; # writes /var/log/plymouth-debug.log
  custom.plymouthThemeAdi1090x.enable = true;
  custom.plymouthThemeAdi1090x.theme = "circuit";

  # Hardware
  custom.amdRyzen93900x.enable = true; # Ryzen 9 3900X profile (ryzen + pstate + zenpower)
  # custom.nomodeset.enable = true;
  # custom.nomodeset.efifbMode = "2560x1440-32@100";
  custom.amdRadeonR7430.enable = true;
  # custom.nvidiaGtx1060.enable = true;   # ← uncomment (and comment amdRadeonR7430 above) to swap GPU
  # custom.nvidiaRtx3070Lhr.enable = true; # ← uncomment (and comment amdRadeonR7430 above) to swap GPU
  custom.ssd.enable = true;

  # Memory
  custom.zram.enable = true;
  custom.earlyoom.enable = true;
  custom.hibernate.enable = true;

  # System
  custom.systemPackages.enable = true;
  custom.bashCompletion.enable = true;
  custom.console.enable = true;
  custom.timezone.enable = true;
  custom.i18n.enable = true;
  custom.fonts.enable = true;
  custom.networkTuning.enable = true;

  # Display
  # custom.ly.enable = true;
  # custom.greetd.enable = true;
  # custom.greetd.swayOutputConfig = ''
  #   output DP-1 mode 2560x1440@100Hz position 0 0
  #   output DP-2 mode 1920x1200@100Hz transform 90 position 2560 0
  # '';
  custom.sddm.enable = true;
  custom.sddmMonitorLayout.enable = true;
  custom.sddmMonitorLayout.disabledOutputs = [ "DP-2" ]; # login screen on primary only
  custom.sddmInputConfig.enable = true;
  custom.kdePlasma.enable = true;

  # Input
  custom.logitechMouse.enable = true;
  custom.wacom.enable = true;

  # Peripherals
  custom.bluetooth.enable = true;
  custom.pipewire.enable = true;

  # Security
  custom.yubikey.enable = true;
  custom.fprintd.enable = true;

  # Services
  custom.printing.enable = true;
  custom.fwupd.enable = true;
  custom.docker.enable = true;
  custom.mullvad.enable = true;
  custom.postinstall.enable = true;

  # Apps
  custom.adb.enable = true;
  custom.coolercontrol.enable = true;
  custom.libvirtd.enable = true;
}
