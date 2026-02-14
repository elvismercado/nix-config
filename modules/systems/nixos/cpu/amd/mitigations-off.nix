# CPU vulnerability mitigations — disable all kernel-level mitigations
#
# Adds "mitigations=off" to the kernel command line, which disables all
# speculative-execution vulnerability mitigations in one shot:
#   - Spectre v1/v2 (branch target injection)
#   - Retbleed (return-address speculation)
#   - SRSO / Inception (speculative return stack overflow — Zen 3/4)
#   - SSB (speculative store bypass)
#   - MDS, TAA, L1TF, MMIO stale data (Intel-only, no-op on AMD)
#
# Performance impact of mitigations on AMD Zen 2/3 (what you get back):
#   - Syscall-heavy / I/O workloads: ~5–10% improvement
#   - Gaming / GPU-bound workloads: ~2–3% improvement
#   - Compile / build workloads: ~3–7% improvement
#
# Security trade-off:
#   These mitigations protect against LOCAL attackers who can already execute
#   code on your machine (e.g. another user, a malicious VM guest, or
#   JavaScript in an un-sandboxed browser).
#
#   For a single-user desktop/gaming machine:
#     ✓ You are the only user — no multi-tenant risk
#     ✓ Your VMs/containers run your own code — not untrusted guests
#     ✓ Browsers already have their own mitigations (site isolation,
#       reduced timer precision) that are far more effective
#     → Kernel mitigations provide negligible additional security
#
#   For servers, multi-user systems, or cloud VMs:
#     ✗ Do NOT disable mitigations — other users/tenants could exploit them
#
# Note: AMD microcode updates (enabled by base.nix) are NOT affected by this
# setting. Microcode fixes hardware bugs at the CPU level with zero performance
# cost and should always remain enabled regardless.
#
# Reference: https://docs.kernel.org/admin-guide/kernel-parameters.html
#            Search for "mitigations="
#
# Verification:
#   cat /proc/cmdline                                      → should contain "mitigations=off"
#   grep . /sys/devices/system/cpu/vulnerabilities/*       → "Vulnerable" or "Not affected" (no "Mitigation:" lines)
#
# To re-enable mitigations, set custom.cpuMitigationsOff.enable = false
# or remove mitigations-off.nix from your CPU profile imports.

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.cpuMitigationsOff.enable = lib.mkEnableOption "disables all CPU vulnerability mitigations (mitigations=off)";
  };

  config = lib.mkIf config.custom.cpuMitigationsOff.enable {
    boot.kernelParams = [ "mitigations=off" ];
  };
}
