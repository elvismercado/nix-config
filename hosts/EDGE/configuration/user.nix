{
  pkgs,
  userSettings,
  ...
}:

{
  # nix.enable is set to false (Determinate Nix manages nix.conf).
  # Uncomment if nix.enable is ever set to true.
  # nix.settings.trusted-users = [ userSettings.username ];

  users.knownUsers = [ userSettings.username ];

  users.users.${userSettings.username} = {
    uid = userSettings.uid;
    description = userSettings.hostname;
    home = "/Users/${userSettings.username}";
    shell = pkgs.bashInteractive;
  };

  networking.hostName = userSettings.hostname;
  networking.computerName = userSettings.hostname;
  networking.localHostName = userSettings.hostname;
  networking.wakeOnLan.enable = true;

  system.defaults.smb.NetBIOSName = userSettings.hostname;
  system.defaults.smb.ServerDescription = userSettings.hostname;
}
