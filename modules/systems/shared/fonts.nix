{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.sysFonts.enable = lib.mkEnableOption "enables shared font packages";
  };

  config = lib.mkIf config.custom.sysFonts.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.departure-mono
      google-fonts
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.commit-mono
    ];
  };
}
