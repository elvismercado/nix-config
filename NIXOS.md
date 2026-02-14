# NixOS

NixOS system configuration is managed through `flake/nixos.nix`. Each NixOS host gets a full system build using `selectedNixpkgs.lib.nixosSystem`, where the nixpkgs version is determined by the host's `channel` setting.

## Current Hosts

| Host   | Architecture | Channel | User   |
| ------ | ------------ | ------- | ------ |
| JIN    | x86_64-linux | stable  | jin    |
| FENNEC | x86_64-linux | stable  | fennec |

## Rebuild

Rebuild the system configuration from the flake:

```bash
# Rebuild using the host's flake configuration
sudo nixos-rebuild switch --flake .#JIN
sudo nixos-rebuild switch --flake .#FENNEC

# Rebuild from the current directory (uses hostname to find config)
sudo nixos-rebuild switch --flake .
```

## How It Works

1. Hosts are registered in `flake/hosts.nix` under `nixosHosts`
2. `flake/nixos.nix` iterates over all NixOS hosts and builds a `nixosSystem` for each
3. The nixpkgs channel (stable/unstable) is selected per-host based on `channel` in `user-settings.nix` via `selectNixpkgs`
4. The Home Manager version (stable/unstable) is also selected per-host via `selectHomeManager` — a `"stable"` host uses `home-manager-stable`, an `"unstable"` host uses `home-manager`
5. The [Determinate Nix](https://determinate.systems/) module is included in all NixOS builds
6. Home Manager is integrated as a NixOS module (not standalone) for system rebuilds

### What gets passed to modules

Every NixOS module receives these via `specialArgs`:

- `inputs` — all flake inputs (access `inputs.nixpkgs-stable`, `inputs.home-manager`, etc.)
- `userSettings` — the host's `user-settings.nix` (`username`, `hostname`, `system`, `channel`, `timeZone`)
- `outputs` — the flake's own outputs

## Toggleable Modules

All modules under `modules/systems/nixos/` use the `custom.*` namespace and must be explicitly enabled. Import the module in your host's `configuration/default.nix` and set the enable flag:

```nix
{
  imports = [
    ../../../modules/systems/nixos/printing.nix
  ];

  custom.printing.enable = true;
}
```

Modules default to `false` — importing without enabling has no effect.

### Available NixOS Modules

| Module                                                   | Option                                |
| -------------------------------------------------------- | ------------------------------------- |
| `systems/nixos/packages.nix`                             | `custom.systemPackages.enable`        |
| **Nix**                                                  |                                       |
| `systems/nixos/nix/enable-flakes.nix`                    | `custom.enableFlakes.enable`          |
| `systems/nixos/nix/garbage.nix`                          | `custom.gc.enable`                    |
| `systems/nixos/printing.nix`                             | `custom.printing.enable`              |
| `systems/nixos/fwupd.nix`                                | `custom.fwupd.enable`                 |
| `systems/nixos/docker.nix`                               | `custom.docker.enable`                |
| `systems/nixos/mullvad.nix`                              | `custom.mullvad.enable`               |
| `systems/nixos/postinstall.nix`                          | `custom.postinstall.enable`           |
| **Peripherals**                                          |                                       |
| `systems/nixos/bluetooth.nix`                            | `custom.bluetooth.enable`             |
| `systems/nixos/pipewire.nix`                             | `custom.pipewire.enable`              |
| **Memory**                                               |                                       |
| `systems/nixos/memory/zram.nix`                          | `custom.zram.enable`                  |
| `systems/nixos/memory/earlyoom.nix`                      | `custom.earlyoom.enable`              |
| `systems/nixos/memory/hibernation.nix`                   | `custom.hibernate.enable`             |
| **Gaming**                                               |                                       |
| `systems/nixos/gaming/steam.nix`                         | `custom.steam.enable`                 |
| **Bootloader**                                           |                                       |
| `systems/nixos/bootloader/grub.nix`                      | `custom.grub.enable`                  |
| `systems/nixos/bootloader/grub-theme-sleek.nix`          | `custom.grubThemeSleek.enable`        |
|                                                          | `custom.grubThemeSleek.style`         |
| `systems/nixos/bootloader/grub-theme-breeze.nix`         | `custom.grubThemeBreeze.enable`       |
| `systems/nixos/bootloader/grub-theme-nixos.nix`          | `custom.grubThemeNixos.enable`        |
| `systems/nixos/bootloader/plymouth.nix`                  | `custom.plymouth.enable`              |
| `systems/nixos/bootloader/plymouth-theme-builtin.nix`    | `custom.plymouthThemeBuiltin.enable`  |
|                                                          | `custom.plymouthThemeBuiltin.theme`   |
| `systems/nixos/bootloader/plymouth-theme-nixos.nix`      | `custom.plymouthThemeNixos.enable`    |
| `systems/nixos/bootloader/plymouth-theme-breeze.nix`     | `custom.plymouthThemeBreeze.enable`   |
| `systems/nixos/bootloader/plymouth-theme-adi1090x.nix`   | `custom.plymouthThemeAdi1090x.enable` |
|                                                          | `custom.plymouthThemeAdi1090x.theme`  |
| **CPU**                                                  |                                       |
| `systems/nixos/cpu/amd/base.nix`                         | `custom.amdCpu.enable`                |
| `systems/nixos/cpu/amd/ryzen.nix`                        | `custom.amdRyzenCpu.enable`           |
| `systems/nixos/cpu/amd/pstate.nix`                       | `custom.amdPstate.enable`             |
| `systems/nixos/cpu/amd/zenpower.nix`                     | `custom.amdZenpower.enable`           |
| **CPU Profiles** (import one per host)                   |                                       |
| `systems/nixos/cpu/amd/ryzen_9_3900x.nix`                | `custom.amdRyzen93900x.enable`        |
| `systems/nixos/cpu/amd/ryzen_9_5900x.nix`                | `custom.amdRyzen95900x.enable`        |
| **Desktop Environment**                                  |                                       |
| `systems/nixos/desktop_environment/cosmic.nix`           | `custom.cosmicDesktop.enable`         |
| `systems/nixos/desktop_environment/kde_plasma.nix`       | `custom.kdePlasma.enable`             |
| **Display Manager**                                      |                                       |
| `systems/nixos/display_manager/sddm.nix`                 | `custom.sddm.enable`                  |
| `systems/nixos/display_manager/sddm-monitor-layout.nix`  | `custom.sddmMonitorLayout.enable`     |
| `systems/nixos/display_manager/sddm-input-config.nix`    | `custom.sddmInputConfig.enable`       |
| **Graphics**                                             |                                       |
| `systems/nixos/graphics/amd_radeon_r7_430.nix`           | `custom.amdRadeonR7430.enable`        |
| `systems/nixos/graphics/intel_arc_a380-intel-driver.nix` | `custom.intelArcIntelDriver.enable`   |
| `systems/nixos/graphics/nvidia_gtx_1060.nix`             | `custom.nvidiaGtx1060.enable`         |
| `systems/nixos/graphics/nvidia_rtx_3070_lhr.nix`         | `custom.nvidiaRtx3070Lhr.enable`      |
| `systems/nixos/graphics/nvidia_rtx_3080.nix`             | `custom.nvidiaRtx3080.enable`         |
| **Graphics — Utilities**                                 |                                       |
| `systems/nixos/graphics/utilities/amd.nix`               | `custom.amdGraphics.enable`           |
| `systems/nixos/graphics/utilities/nomodeset.nix`         | `custom.nomodeset.enable`             |
| `systems/nixos/graphics/utilities/nvtop-intel.nix`       | `custom.nvtopIntel.enable`            |
| `systems/nixos/graphics/utilities/nvtop-nvidia.nix`      | `custom.nvtopNvidia.enable`           |
| **Input**                                                |                                       |
| `systems/nixos/input/wacom.nix`                          | `custom.wacom.enable`                 |
| **Mouse**                                                |                                       |
| `systems/nixos/mouse/logitech.nix`                       | `custom.logitechMouse.enable`         |
| **Security**                                             |                                       |
| `systems/nixos/security/fprintd.nix`                     | `custom.fprintd.enable`               |
| `systems/nixos/security/yubikey.nix`                     | `custom.yubikey.enable`               |
| **SSD**                                                  |                                       |
| `systems/nixos/ssd/default.nix`                          | `custom.ssd.enable`                   |
| **System**                                               |                                       |
| `systems/nixos/system/console.nix`                       | `custom.console.enable`               |
|                                                          | `custom.console.colorScheme`          |
| `systems/nixos/system/fonts.nix`                         | `custom.fonts.enable`                 |
| `systems/nixos/system/i18n.nix`                          | `custom.i18n.enable`                  |
| `systems/nixos/system/time.nix`                          | `custom.timezone.enable`              |
| `systems/nixos/system/network-tuning.nix`                | `custom.networkTuning.enable`         |
| **Apps**                                                 |                                       |
| `systems/nixos/apps/adb.nix`                             | `custom.adb.enable`                   |
| `systems/nixos/apps/coolercontrol.nix`                   | `custom.coolercontrol.enable`         |
| `systems/nixos/apps/libvirtd.nix`                        | `custom.libvirtd.enable`              |
| `systems/nixos/apps/sunshine.nix`                        | `custom.sunshine.enable`              |
| **Shared** (cross-platform)                              |                                       |
| `systems/shared/bash.nix`                                | `custom.bashCompletion.enable`        |
| `systems/shared/fonts.nix`                               | `custom.fonts.enable`                 |
| `systems/shared/packages.nix`                            | `custom.systemPackages.enable`        |
| `systems/shared/ssh-server.nix`                          | `custom.sshServer.enable`             |

> Shared modules are imported indirectly — e.g. `nixos/nix/garbage.nix` imports `shared/garbage.nix` and layers on NixOS-specific `nix.gc` settings. You import the platform wrapper, not the shared file directly.

## Adding a New NixOS Host

1. Create the host directory:

   ```
   hosts/<HOSTNAME>/
     user-settings.nix
     configuration/
       default.nix
       configuration.nix
       hardware-configuration.nix
       user.nix
     home-manager/
       default.nix
       home.nix
   ```

2. Define `user-settings.nix`:

   ```nix
   {
     username = "myuser";
     hostname = "MYHOST";
     system = "x86_64-linux";
     channel = "stable"; # or "unstable"
     timeZone = "Europe/Amsterdam";
   }
   ```

3. Generate the hardware configuration:

   ```bash
   nixos-generate-config --show-hardware-config > hosts/<HOSTNAME>/configuration/hardware-configuration.nix
   ```

4. Register the host in `flake/hosts.nix`:

   ```nix
   nixosHosts = {
     MYHOST = mkHost "MYHOST";
   };
   ```

5. Rebuild:

   ```bash
   sudo nixos-rebuild switch --flake .#MYHOST
   ```

## Garbage Collection

```bash
# Delete all old generations
nix-collect-garbage -d

# Delete generations older than 7 days
nix-collect-garbage --delete-older-than 7d
```

> With Determinate Nix, managed garbage collection runs automatically in the background via Determinate Nixd.
