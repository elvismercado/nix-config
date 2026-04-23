# Manage dotfiles and user packages

{
  pkgs,
  config,
  ...
}:

{
  imports = [
    # Host
    ./configuration.nix
    # enable-flakes.nix is not needed — Determinate Nix already enables flakes,
    # and nix.enable = false means nix.settings is not managed by nix-darwin.
    ./user.nix

    # Darwin / UI
    ../../../modules/systems/darwin/dock.nix
    ../../../modules/systems/darwin/finder.nix
    ../../../modules/systems/darwin/control-center.nix
    ../../../modules/systems/darwin/system-preferences.nix
    ../../../modules/systems/darwin/trackpad.nix

    # Darwin / System
    ../../../modules/systems/darwin/packages.nix
    ../../../modules/systems/darwin/fonts.nix
    ../../../modules/systems/darwin/power.nix
    ../../../modules/systems/darwin/security.nix

    # Shared
    ../../../modules/systems/shared/bash.nix
  ];

  homebrew = {
    enable = true;
    brews = [
      "mpv" # CLI/GUI media player (no cask available)
    ];
    casks = [
      # Window management
      "rectangle"

      # Browsers & Communication
      "brave-browser"
      "discord"
      "librewolf" # deprecated in Homebrew Sep 2026 — revisit before then
      "signal"

      # Media
      "handbrake-app"
      "moonlight"
      "shotcut"
      "spotify"
      "steam"
      "vlc"

      # Productivity
      "beeper"
      "ferdium"
      "nextcloud"
      "orbstack"
      "syncthing-app"

      # Email
      "thunderbird"

      # Security & VPN
      "mullvad-vpn"
      "proton-mail-bridge"

      # Development
      "visual-studio-code"

      # System & Hardware
      "appcleaner"
      "insync"
      "libreoffice"
      "localsend"
      "raspberry-pi-imager"
      "sweet-home3d"
      "the-unarchiver"
      "unraid-usb-creator-next"
      "yubico-authenticator"
    ];
    masApps = {
      "WireGuard" = 1451685025;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "uninstall"; # remove packages not in config
    };
  };

  environment.shells = [ pkgs.bashInteractive ];
  environment.variables.LANG = "en_GB.UTF-8";

  # Darwin / UI
  custom.sysDarControlCenter.enable = true;
  custom.sysDarDock.enable = true;
  custom.sysDarFinder.enable = true;
  custom.sysDarPreferences.enable = true;
  custom.sysDarTrackpad.enable = true;

  # Darwin / System
  custom.sysPackages.enable = true;
  custom.sysFonts.enable = true;
  custom.sysDarPower.enable = true;
  custom.sysDarSecurity.enable = true;

  # Shared
  custom.sysBashCompletion.enable = true;
}
