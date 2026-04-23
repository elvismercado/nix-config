# Thunderbird email client — declarative profile via programs.thunderbird
#
# Email accounts are managed via the Thunderbird GUI, not declared here.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/thunderbird.nix ];
#   custom.hmThunderbird.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmThunderbird.enable = lib.mkEnableOption "Thunderbird email client (declarative profile; accounts managed via the GUI)";
  };

  config = lib.mkIf config.custom.hmThunderbird.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };

    home.packages = with pkgs; [
      hunspell
      hunspellDicts.en_GB-large
      hunspellDicts.nl_NL
      hunspellDicts.es_ES
      hunspellDicts.en_US-large
    ];
  };
}
