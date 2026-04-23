{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysNixNvtopIntel.enable = lib.mkEnableOption "nvtop GPU process viewer with Intel support";
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
