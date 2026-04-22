{
  pkgs,
  userSettings,
  ...
}:

{
  users.mutableUsers = true;

  users.defaultUserShell = pkgs.bash;

  users.users.${userSettings.username} = {
    uid = userSettings.uid;
    isNormalUser = true;
    description = userSettings.hostname;
    initialPassword = userSettings.username;
    useDefaultShell = true;

    extraGroups = [
      "networkmanager" # Wi-Fi and network management
      "wheel" # sudo access
      "video" # GPU and display device access
      "render" # GPU rendering (e.g. Vulkan, OpenCL)
    ];
  };

  networking.hostName = userSettings.hostname;
}
