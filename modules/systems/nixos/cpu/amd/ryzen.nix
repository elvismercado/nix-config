# AMD Ryzen — Ryzen-specific CPU features (Zen architecture)
# Imports the base AMD CPU module (base.nix) and adds Ryzen-specific hardware
# features for virtualisation security, power monitoring, and diagnostics.
#
# Supported: Zen (1000), Zen+ (2000), Zen 2 (3000), Zen 3 (5000), Zen 4 (7000), Zen 5+
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/cpu/amd/ryzen.nix ];
#   custom.sysNixAmdRyzenCpu.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./base.nix # base AMD CPU support (microcode updates)
  ];

  options = {
    custom.sysNixAmdRyzenCpu.enable = lib.mkEnableOption "AMD Ryzen (Zen 1–5+) extras: virtualisation security, power monitoring, diagnostics";
  };

  config = lib.mkIf config.custom.sysNixAmdRyzenCpu.enable {
    # Auto-enable the base AMD CPU module
    custom.sysNixAmdCpu.enable = true;

    # Load the kvm-amd kernel module — enables hardware-accelerated virtualisation
    # (AMD-V / SVM) for QEMU/KVM virtual machines. This is the AMD equivalent of
    # Intel's kvm-intel. Without this module, VMs fall back to slow software emulation.
    # Note: also set by nixos-generate-config in hardware-configuration.nix, but we
    # declare it here so the module is self-contained. Duplicate entries are harmless
    # in NixOS (lists are merged).
    boot.kernelModules = [ "kvm-amd" ];

    hardware.cpu.amd = {
      # AMD Secure Encrypted Virtualization (SEV) — encrypts VM memory so that
      # even the hypervisor cannot read guest data. Useful when running VMs with
      # libvirtd/QEMU. This enables the host-side SEV support.
      sev.enable = true;
      # sevGuest.enable = true; # Enable this inside a VM to use SEV as a guest

      # Ryzen System Management Unit (SMU) access — exposes low-level CPU data
      # to userspace: power draw per socket, voltage per core, thermal limits,
      # and boost clock states. Required by tools like ryzen-monitor-ng.
      ryzen-smu.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # lm_sensors — provides the `sensors` CLI command for reading hardware
      # temperature, voltage, and fan speed data from kernel drivers.
      # Also includes `sensors-detect` to discover available sensor chips.
      lm_sensors

      # ryzen-monitor-ng — reads Ryzen-specific SMU (System Management Unit)
      # data not visible to standard tools: per-core effective clocks, peak
      # frequencies, power consumption, and silicon fitness/quality metrics.
      ryzen-monitor-ng
    ];
  };
}
