# Network & I/O tuning — sysctl and service optimisations
#
# A collection of kernel tunables that improve network throughput,
# reduce latency, and prevent resource-limit issues on desktop systems:
#
#   - TCP BBR congestion control — Google's algorithm for higher throughput
#     and lower latency, especially effective over VPNs (e.g. Mullvad)
#   - fq (Fair Queue) qdisc — pairs with BBR for optimal pacing
#   - irqbalance — distributes hardware interrupts across all CPU cores
#     instead of funnelling everything through core 0
#
# Note: inotify max_user_watches is already set to 524288 by NixOS 25.11+
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/system/network-tuning.nix ];
#   custom.networkTuning.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.networkTuning.enable = lib.mkEnableOption "enables network and I/O tuning";
  };

  config = lib.mkIf config.custom.networkTuning.enable {

    # --- TCP congestion control ---
    boot.kernel.sysctl = {
      # Fair Queue qdisc — provides per-flow pacing, required for BBR
      "net.core.default_qdisc" = lib.mkDefault "fq";

      # BBR congestion control — significantly better throughput and
      # lower latency than the default cubic, especially over VPNs.
      "net.ipv4.tcp_congestion_control" = lib.mkDefault "bbr";
    };

    # --- IRQ balancing ---
    # Distributes hardware interrupts (NVMe, GPU, NIC, USB) across
    # all available CPU cores. Without this, all IRQs land on core 0
    # which can bottleneck I/O on multi-core systems.
    services.irqbalance.enable = lib.mkDefault true;
  };
}
