# Manage dotfiles and user packages

{ userSettings, ... }:

{
  nixpkgs.hostPlatform = userSettings.system;
  system.stateVersion = 6; # required
  system.primaryUser = userSettings.username; # required for homebrew.enable and other per-user options
  nix.enable = false; # using determinate installer
}
