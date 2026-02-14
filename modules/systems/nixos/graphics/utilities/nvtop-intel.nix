{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.nvtopIntel.enable = lib.mkEnableOption "enables nvtop for Intel GPUs";
  };

  config = lib.mkIf config.custom.nvtopIntel.enable {
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
