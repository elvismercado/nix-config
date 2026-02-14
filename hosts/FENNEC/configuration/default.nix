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
    ../../../modules/systems/nixos/cpu/amd/ryzen_9_5900x.nix
    ../../../modules/systems/nixos/graphics/nvidia_rtx_3080.nix
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
    ../../../modules/systems/nixos/display_manager/sddm.nix
    ../../../modules/systems/nixos/desktop_environment/kde_plasma.nix

    # Peripherals
    ../../../modules/systems/nixos/bluetooth.nix
    ../../../modules/systems/nixos/pipewire.nix
    ../../../modules/systems/nixos/mouse/logitech.nix

    # Services
    ../../../modules/systems/nixos/fwupd.nix
    ../../../modules/systems/nixos/mullvad.nix
    ../../../modules/systems/nixos/postinstall.nix

    # Apps
    ../../../modules/systems/nixos/apps/coolercontrol.nix
    ../../../modules/systems/nixos/apps/sunshine.nix

    # Gaming
    ../../../modules/systems/nixos/gaming/steam.nix
  ];

  # Nix
  custom.enableFlakes.enable = true;
  custom.gc.enable = true;

  # Bootloader
  custom.grub.enable = true;
  custom.grub.timeout = 5; # dual-boot — give time to select OS
  custom.grubThemeSleek.enable = true;
  custom.grubThemeSleek.style = "dark";
  custom.plymouth.enable = true;
  custom.plymouth.minAnimationDuration = 3; # NVMe boots fast — ensure animation plays
  custom.plymouth.minShutdownDuration = 3;
  custom.plymouthThemeAdi1090x.enable = true;
  custom.plymouthThemeAdi1090x.theme = "circuit";

  # Hardware
  custom.amdRyzen95900x.enable = true;
  custom.nvidiaRtx3080.enable = true;
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
  custom.sddm.enable = true;
  custom.kdePlasma.enable = true;

  # Peripherals
  custom.bluetooth.enable = true;
  custom.pipewire.enable = true;
  custom.logitechMouse.enable = true;

  # Services
  custom.fwupd.enable = true;
  custom.mullvad.enable = true;
  custom.postinstall.enable = true;

  # Apps
  custom.coolercontrol.enable = true;
  custom.sunshine.enable = true;

  # Gaming
  custom.steam.enable = true;
}
