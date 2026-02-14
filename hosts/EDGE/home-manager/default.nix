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

    # macOS
    ../../../modules/home-manager/darwin/rectangle.nix
  ];

  # Enable imported modules
  custom.hmBase.enable = true;
  custom.hmAliases.enable = true;
  custom.android.enable = true;
  custom.ansible.enable = true;
  custom.bash.enable = true;
  custom.fastfetch.enable = true;
  custom.fnm.enable = true;
  custom.git.enable = true;
  custom.pyenv.enable = true;
  custom.ssh.enable = true;
  custom.starship.enable = true;
  custom.starship.style = "pastel-powerline";

  # macOS
  custom.rectangle.enable = true;
}
