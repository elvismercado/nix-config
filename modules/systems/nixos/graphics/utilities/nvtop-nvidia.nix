{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.nvtopNvidia.enable = lib.mkEnableOption "enables nvtop for NVIDIA GPUs";
  };

  config = lib.mkIf config.custom.nvtopNvidia.enable {
    # List packages installed in system profile. (all users)
    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
    ];
  };
}
