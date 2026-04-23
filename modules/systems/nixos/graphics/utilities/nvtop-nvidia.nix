{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysNixNvtopNvidia.enable = lib.mkEnableOption "nvtop GPU process viewer with NVIDIA support";
  };

  config = lib.mkIf config.custom.sysNixNvtopNvidia.enable {
    # List packages installed in system profile. (all users)
    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
