# Manage dotfiles and user packages

{
  ...
}:

{
  imports = [
    # Host
    ./home.nix

    # Base
    ../../../modules/home-manager/all/base.nix

    # Shell
    ../../../modules/home-manager/all/aliases.nix
    ../../../modules/home-manager/all/bash.nix
    ../../../modules/home-manager/all/fastfetch.nix
    ../../../modules/home-manager/all/git.nix
    ../../../modules/home-manager/all/ssh.nix
    ../../../modules/home-manager/all/starship.nix

    # Apps
    ../../../modules/home-manager/all/brave.nix
    ../../../modules/home-manager/all/mpv.nix
    ../../../modules/home-manager/all/vscode.nix
    ../../../modules/home-manager/all/syncthing.nix

    # Linux
    ../../../modules/home-manager/linux/aliases.nix
    ../../../modules/home-manager/linux/window-shortcuts.nix
    ../../../modules/home-manager/linux/display-profiles.nix

    # Linux / KDE Plasma
    ../../../modules/home-manager/linux/plasma-config.nix

    # Linux / Gaming
    ../../../modules/home-manager/linux/gaming.nix

    # Linux / Apps
    ../../../modules/home-manager/linux/handbrake.nix
    ../../../modules/home-manager/linux/strawberry.nix
    ../../../modules/home-manager/linux/vesktop.nix

    # Linux / Utilities
    ../../../modules/home-manager/linux/linutil.nix
  ];

  # Base
  custom.hmBase.enable = true;

  # Shell
  custom.hmAliases.enable = true;
  custom.bash.enable = true;
  custom.fastfetch.enable = true;
  custom.git.enable = true;
  custom.ssh.enable = true;
  custom.starship.enable = true;
  custom.starship.style = "pastel-powerline";

  # Apps
  custom.brave.enable = true;
  custom.hmMpv.enable = true;
  custom.vscode.enable = true;
  custom.syncthing.enable = true;

  # Linux
  custom.hmLinuxAliases.enable = true;
  custom.windowShortcuts.enable = true;
  custom.displayProfiles.enable = true;

  # Linux / KDE Plasma
  custom.plasmaConfig.enable = true;

  # Linux / Gaming
  custom.hmGaming.enable = true;

  # Linux / Apps
  custom.hmHandbrake.enable = true;
  custom.hmStrawberry.enable = true;
  custom.hmVesktop.enable = true;

  # Linux / Utilities
  custom.hmLinutil.enable = true;
}
