{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.systemPackages.enable = lib.mkEnableOption "enables base system packages";
  };

  config = lib.mkIf config.custom.systemPackages.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
      nano
    ];
  };
}
