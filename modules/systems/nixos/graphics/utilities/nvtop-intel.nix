{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysNixNvtopIntel.enable = lib.mkEnableOption "enables nvtop for Intel GPUs";
  };

  config = lib.mkIf config.custom.sysNixNvtopIntel.enable {
    # List packages installed in system profile. (all users)
    environment.systemPackages = with pkgs; [
      nvtopPackages.intel
    ];

    security.wrappers.nvtop = {
      source = "${pkgs.nvtopPackages.intel}/bin/nvtop";
      capabilities = "cap_perfmon=ep";
      owner = "root";
      group = "root";
    };
  };
}
