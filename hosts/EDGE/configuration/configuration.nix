# Manage dotfiles and user packages

{ userSettings, ... }:

{
  nixpkgs.hostPlatform = "x86_64-darwin"; # required
  system.stateVersion = 6; # required
  system.primaryUser = userSettings.username; # required for homebrew.enable and other per-user options
  nix.enable = false; # using determinate installer
}
