# Thunderbird email client
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
    custom.hmThunderbird.enable = lib.mkEnableOption "enables thunderbird";
  };

  config = lib.mkIf config.custom.hmThunderbird.enable {
    home.packages = with pkgs; [
      thunderbird
      hunspell
      hunspellDicts.en_GB-large
      hunspellDicts.nl_NL
      hunspellDicts.es_ES
      hunspellDicts.en_US-large
    ];

    # programs.thunderbird = {
    #   enable = true;
    #   settings = {
    #   };
    # };

    # accounts.email.accounts = {
    #   "e.m.mercadocruz@gmail.com" = {
    #     address = "e.m.mercadocruz@gmail.com";
    #     # thunderbird.settings = {};
    #   };
    # };
  };
}
