# AMD CPU — base module for all AMD processors
# This is the foundation imported by all AMD-specific modules (ryzen, pstate, zenpower).
# You typically don't enable this directly — it gets auto-enabled by the modules that import it.

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.amdCpu.enable = lib.mkEnableOption "enables AMD CPU support";
  };

  config = lib.mkIf config.custom.amdCpu.enable {
    hardware.cpu.amd = {
      # Apply AMD CPU microcode updates at boot.
      # Microcode patches fix CPU-level bugs (security vulnerabilities like Spectre/Meltdown,
      # stability issues, errata). These are loaded by the kernel before userspace starts.
      # Requires hardware.enableRedistributableFirmware (enabled by default on NixOS).
      updateMicrocode = true;
    };
  };
}
