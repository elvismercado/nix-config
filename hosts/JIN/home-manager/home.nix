# Host-specific Home Manager config for JIN

{
  lib,
  userSettings,
  ...
}:

{
  home.username = lib.mkDefault userSettings.username;
  home.homeDirectory = lib.mkDefault "/home/${userSettings.username}";
  home.stateVersion = "25.11";
}
