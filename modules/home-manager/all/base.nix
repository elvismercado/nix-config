{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:

{
  options.custom.hmBase.enable = lib.mkEnableOption "enables shared Home Manager base config";

  config = lib.mkIf config.custom.hmBase.enable {
    home.packages = with pkgs; [
      cowsay
      lolcat
      nixfmt-tree
      nil
    ];

    home.sessionVariables = {
      EDITOR = "nano";
    };
  };
}
