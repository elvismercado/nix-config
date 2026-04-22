# Manage dotfiles and user packages

{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./configuration.nix
    # enable-flakes.nix is not needed — Determinate Nix already enables flakes,
    # and nix.enable = false means nix.settings is not managed by nix-darwin.
    ./user.nix

    ../../../modules/systems/darwin/dock.nix
    ../../../modules/systems/darwin/finder.nix
    ../../../modules/systems/darwin/control-center.nix
    ../../../modules/systems/darwin/system-preferences.nix
    ../../../modules/systems/darwin/trackpad.nix
    ../../../modules/systems/darwin/packages.nix
    ../../../modules/systems/darwin/fonts.nix
    ../../../modules/systems/darwin/power.nix
    ../../../modules/systems/darwin/security.nix

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

  custom.controlCenter.enable = true;
  custom.dock.enable = true;
  custom.finder.enable = true;
  custom.systemPreferences.enable = true;
  custom.trackpad.enable = true;
  custom.systemPackages.enable = true;
  custom.bashCompletion.enable = true;
  custom.fonts.enable = true;
  custom.power.enable = true;
  custom.security.enable = true;
}
