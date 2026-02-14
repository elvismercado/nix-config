# AMD P-State — CPU frequency scaling driver for Zen CPUs
# https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
#
# Replaces the default acpi-cpufreq driver with AMD's own P-State driver,
# which understands Zen power states natively. This gives finer-grained
# frequency steps and better performance-per-watt.
#
# Modes:
#   active  — the hardware (CPPC) decides frequency autonomously (best efficiency)
#   passive — the kernel governor controls frequency via CPPC hints
#   guided  — kernel sets min/max, hardware picks within that range
#
# "active" mode (amd_pstate_epp) is recommended for Zen 2+ on kernel 6.3+.
#
# Supported: Zen 2 (Ryzen 3000), Zen 3 (Ryzen 5000), Zen 4 (Ryzen 7000), Zen 5+
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/cpu/amd/pstate.nix ];
#   custom.amdPstate.enable = true;

{
  config,
  lib,
  ...
}:

{
  imports = [
    ./base.nix # base AMD CPU support (microcode updates)
  ];

  options = {
    custom.amdPstate.enable = lib.mkEnableOption "enables AMD P-State CPU frequency scaling driver";
  };

  config = lib.mkIf config.custom.amdPstate.enable {
    # Auto-enable the base AMD CPU module
    custom.amdCpu.enable = true;

    # Tell the kernel to use the AMD P-State EPP driver in active mode.
    # In active mode, the CPU's internal firmware (CPPC) autonomously selects
    # the optimal frequency/voltage, resulting in better power efficiency
    # than the generic acpi-cpufreq driver.
    boot.kernelParams = [ "amd_pstate=active" ];
  };
}
