# AMD Ryzen 9 5900X — CPU profile
# Zen 3 · 12 cores / 24 threads · 3.7 GHz base / 4.8 GHz boost · 105 W TDP
# https://www.amd.com/en/products/processors/amd-ryzen-9-5900x
#
# This is a convenience profile that imports and enables all relevant AMD
# modules for this CPU. Import this single file in your host config instead
# of importing each module individually.
#
# Enables:
#   - base.nix            — AMD microcode updates
#   - ryzen.nix           — kvm-amd, SEV, SMU, lm_sensors, ryzen-monitor-ng
#   - pstate.nix          — AMD P-State EPP frequency scaling (active mode)
#   - zenpower.nix        — Zenpower sensor driver (replaces k10temp)
#   - zen-kernel.nix      — Linux Zen kernel (desktop-optimised, 1000 Hz)
#   - mitigations-off.nix — disable CPU vulnerability mitigations (single-user desktop)
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/cpu/amd/ryzen_9_5900x.nix ];
#   custom.amdRyzen95900x.enable = true;

{
  config,
  lib,
  ...
}:

{
  imports = [
    ./ryzen.nix
    ./pstate.nix
    ./zenpower.nix
    ./zen-kernel.nix
    ./mitigations-off.nix
  ];

  options = {
    custom.amdRyzen95900x.enable = lib.mkEnableOption "enables AMD Ryzen 9 5900X CPU profile";
  };

  config = lib.mkIf config.custom.amdRyzen95900x.enable {
    custom.amdRyzenCpu.enable = true;
    custom.amdPstate.enable = true;
    custom.amdZenpower.enable = true;
    custom.zenKernel.enable = true;
    custom.cpuMitigationsOff.enable = true;
  };
}
