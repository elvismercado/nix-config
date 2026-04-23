# zram — compressed swap in RAM
# https://wiki.archlinux.org/title/Zram
#
# Creates a compressed block device in RAM that acts as swap space.
# Pages are compressed with zstd before being "swapped", so they stay
# in memory but take up less room. Benefits:
#
#   - Much faster than NVMe swap (no disk I/O at all)
#   - Reduces SSD wear from swap writes
#   - Improves responsiveness under memory pressure
#   - Negligible CPU overhead on modern multi-core CPUs (zstd is fast)
#
# zram coexists with any physical swap partition — the kernel will
# prefer zram (higher priority) and fall back to disk swap when zram
# is full.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/memory/zram.nix ];
#   custom.sysNixZram.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixZram.enable = lib.mkEnableOption "zram compressed swap (in-RAM swap device)";
  };

  config = lib.mkIf config.custom.sysNixZram.enable {
    zramSwap = {
      enable = lib.mkDefault true;

      # zstd offers the best compression ratio with low CPU cost,
      # ideal for Zen 2+ CPUs.
      algorithm = lib.mkDefault "zstd";

      # Use up to 50% of physical RAM for the compressed swap device.
      # Effective capacity is higher because pages compress ~2-3×.
      memoryPercent = lib.mkDefault 50;
    };

    # With zram, "swap" is compressed RAM — orders of magnitude faster
    # than disk. A higher swappiness lets the kernel move cold pages
    # into zram's compressed space, freeing physical RAM for active use
    # and filesystem cache. Values above 100 are supported since
    # Linux 5.8 (the Zen kernel qualifies).
    #
    # mkOverride 900 ensures this takes priority over the SSD module's
    # mkDefault (priority 1000) swappiness of 10, which is tuned for
    # disk-only swap.
    boot.kernel.sysctl."vm.swappiness" = lib.mkOverride 900 180;
  };
}
