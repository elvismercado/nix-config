# System Preferences — macOS system defaults
#
# Configures NSGlobalDomain, screencapture, screensaver, login window,
# menu bar clock, Window Manager, Spaces, accessibility, Launch Services,
# and custom per-app preferences via system.defaults.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/system-preferences.nix ];
#   custom.sysDarPreferences.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarPreferences.enable = lib.mkEnableOption "macOS system defaults (NSGlobalDomain, screencapture, login window, menu bar clock, etc.)";
  };

  config = lib.mkIf config.custom.sysDarPreferences.enable {
    system.defaults.NSGlobalDomain = {
      # Appearance
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = false;
      _HIHideMenuBar = false;
      NSStatusItemSpacing = 12;
      NSStatusItemSelectionPadding = 8;

      # Window animations
      NSWindowResizeTime = 0.1; # Near-instant resize (default 0.2)
      NSAutomaticWindowAnimationsEnabled = false; # Disable open/close animations

      # Keyboard
      InitialKeyRepeat = 10; # Very fast initial delay (default 25)
      KeyRepeat = 2; # Fast repeat rate (default 6)
      ApplePressAndHoldEnabled = false; # Key repeat instead of accent menu
      "com.apple.keyboard.fnState" = false; # Fn keys = media/brightness
      AppleKeyboardUIMode = 3; # Tab through all UI controls

      # Text input corrections — all disabled
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;

      # Finder / files
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTableViewDefaultSizeMode = 2; # Medium sidebar icons

      # Scrolling
      AppleShowScrollBars = "Automatic";
      NSScrollAnimationEnabled = true;
      AppleScrollerPagingBehavior = true; # Jump to clicked spot
      NSUseAnimatedFocusRing = true;

      # Dialogs
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      AppleWindowTabbingMode = "manual";

      # Locale & units
      AppleICUForce24HourTime = true;
      AppleMetricUnits = 1;
      AppleMeasurementUnits = "Centimeters";
      AppleTemperatureUnit = "Celsius";

      # Sound
      "com.apple.sound.beep.volume" = 0.25;
      "com.apple.sound.beep.feedback" = 1;

      # Spring loading
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.25;

      # Navigation & misc
      AppleEnableSwipeNavigateWithScrolls = true;
      AppleSpacesSwitchOnActivate = true;
      NSTextShowsControlCharacters = true;
    };

    # Screenshots
    system.defaults.screencapture = {
      location = "~/Desktop";
      type = "jpg";
      disable-shadow = true;
      show-thumbnail = true;
      include-date = true;
      target = "clipboard";
    };

    # Screensaver
    system.defaults.screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
    };

    # Login window
    system.defaults.loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = false; # false = user list with icons, true = username+password text fields
    };

    # Menu bar clock
    system.defaults.menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = false;
      ShowDayOfWeek = true;
      ShowDate = 1; # Day of month only
      FlashDateSeparators = false;
      IsAnalog = false;
    };

    # Window Manager
    system.defaults.WindowManager = {
      GloballyEnabled = false; # Stage Manager off
      EnableStandardClickToShowDesktop = true;
      EnableTilingByEdgeDrag = true;
      EnableTopTilingByEdgeDrag = true;
      EnableTilingOptionAccelerator = true;
      EnableTiledWindowMargins = false;
    };

    # Accessibility
    # universalaccess.reduceTransparency cannot be set via nix-darwin —
    # com.apple.universalaccess is protected by SIP/TCC (nix-darwin#705).
    # Set manually: System Preferences > Accessibility > Display > Reduce transparency.

    # Custom per-app preferences
    system.defaults.CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.ImageCapture" = {
        disableHotPlug = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      NSGlobalDomain = {
        WebKitDeveloperExtras = true;
      };
    };
  };
}
