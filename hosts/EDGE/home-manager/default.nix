# Manage dotfiles and user packages

{
  ...
}:

{
  imports = [
    ./home.nix

    ../../../modules/home-manager/all/base.nix
    ../../../modules/home-manager/all/aliases.nix
    ../../../modules/home-manager/all/android.nix
    ../../../modules/home-manager/all/ansible.nix
    ../../../modules/home-manager/all/bash.nix
    ../../../modules/home-manager/all/fastfetch.nix
    ../../../modules/home-manager/all/fnm.nix
    ../../../modules/home-manager/all/git.nix
    ../../../modules/home-manager/all/pyenv.nix
    ../../../modules/home-manager/all/ssh.nix
    ../../../modules/home-manager/all/starship.nix

    # Packages
    ../../../modules/home-manager/all/packages.nix

    # macOS
    ../../../modules/home-manager/darwin/rectangle.nix
    ../../../modules/home-manager/darwin/aliases.nix
  ];

  # Enable imported modules
  custom.hmBase.enable = true;
  custom.hmAliases.enable = true;
  custom.hmAndroid.enable = true;
  custom.hmAnsible.enable = true;
  custom.hmBash.enable = true;
  custom.hmFastfetch.enable = true;
  custom.hmFnm.enable = true;
  custom.hmGit.enable = true;
  custom.hmPyenv.enable = true;
  custom.hmSsh.enable = true;
  custom.hmStarship.enable = true;
  custom.hmStarship.style = "pastel-powerline";

  # Packages
  custom.hmPackages.enable = true;

  # macOS
  custom.hmRectangle.enable = true;
  custom.hmDarwinAliases.enable = true;
}
