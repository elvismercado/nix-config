{
  config,
  lib,
  ...
}:

{
  options = {
    custom.ssd.enable = lib.mkEnableOption "enables SSD optimizations";
  };

  config = lib.mkIf config.custom.ssd.enable {

    # --- TRIM ---
    # Periodic TRIM reclaims unused blocks; preferred over continuous discard
    # which adds latency to every delete operation.
    services.fstrim.enable = lib.mkDefault true;
    # services.fstrim.interval = "weekly"; # default is already weekly

    # --- Mount options ---
    # Disable access-time writes on root — eliminates a significant source
    # of unnecessary write I/O, especially on QLC NAND.
    fileSystems."/".options = [ "noatime" ];

    # --- tmpfs for /tmp ---
    # Keep build artifacts (Nix builds, compilers, etc.) and general temp
    # files entirely in RAM so they never touch the SSD.
    boot.tmp.useTmpfs = lib.mkDefault true;
    boot.tmp.tmpfsSize = lib.mkDefault "75%";

    # --- Kernel tuning ---
    boot.kernel.sysctl = {
      # Reduce swap eagerness (default 60 is too aggressive for SSD desktops
      # with plenty of RAM — keeps apps in memory, fewer SSD writes).
      "vm.swappiness" = lib.mkDefault 10;

      # Keep filesystem metadata (dentries/inodes) cached in RAM longer,
      # reducing repeated disk reads.
      "vm.vfs_cache_pressure" = lib.mkDefault 50;

      # Limit how much dirty data accumulates before the kernel flushes to
      # disk, reducing write amplification on the SSD.
      "vm.dirty_ratio" = lib.mkDefault 10;
      "vm.dirty_background_ratio" = lib.mkDefault 5;
    };

    # --- I/O scheduler ---
    # NVMe devices have their own internal scheduler; the kernel's software
    # scheduler adds overhead. "none" (noop) is already the kernel default
    # for NVMe but this makes it explicit via udev.
    # services.udev.extraRules = ''
    #   ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    # '';
  };
}
