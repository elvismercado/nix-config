# Host-specific Home Manager config for EDGE

{
  userSettings,
  ...
}:

{
  home.username = userSettings.username;
  home.homeDirectory = "/Users/${userSettings.username}";
  home.stateVersion = "25.11";
}
