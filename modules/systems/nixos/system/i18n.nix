{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixI18n.enable = lib.mkEnableOption "i18n / locale configuration (en_GB.UTF-8)";
  };

  config = lib.mkIf config.custom.sysNixI18n.enable {
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.defaultCharset = "UTF-8";

    i18n.extraLocales = [
      "en_GB.UTF-8/UTF-8"
      "nl_NL.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8" # Supporting because its 'most defaulted to', 'most common', 'most assumed' etc.
    ];

    i18n.extraLocaleSettings = {
      # LC_ALL = ""; # Overrides all locale categories when set
      LC_CTYPE = "en_GB.UTF-8"; # Character classification and case conversion
      LC_MESSAGES = "en_GB.UTF-8"; # UI language and system messages
      LC_COLLATE = "en_GB.UTF-8"; # Sorting order

      # Dutch regional settings
      LC_ADDRESS = "nl_NL.UTF-8"; # Address formatting
      LC_IDENTIFICATION = "nl_NL.UTF-8"; # Locale metadata
      LC_MEASUREMENT = "nl_NL.UTF-8"; # Measurement units
      LC_MONETARY = "nl_NL.UTF-8"; # Currency formatting
      LC_NAME = "nl_NL.UTF-8"; # Personal name formatting
      LC_NUMERIC = "nl_NL.UTF-8"; # Numeric formatting
      LC_PAPER = "nl_NL.UTF-8"; # Paper size
      LC_TELEPHONE = "nl_NL.UTF-8"; # Telephone number formatting
      LC_TIME = "nl_NL.UTF-8"; # Date and time formats
    };
  };
}
