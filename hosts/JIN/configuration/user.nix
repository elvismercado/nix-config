{
  pkgs,
  userSettings, # from user-settings.nix
  ...
}:

{
  users.mutableUsers = true; # If set to true, you are free to add new users and groups to the system with the ordinary useradd and groupadd commands.

  users.defaultUserShell = pkgs.bash;
  # users.defaultUserShell = pkgs.fish;

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
      "docker" # Run Docker containers without sudo
      "libvirtd" # QEMU/KVM virtual machine management
      "dialout" # Serial device access (Arduino, embedded development)
      "adbusers" # Android Debug Bridge (ADB) device access
      # "audio" # Direct audio device access (rarely needed with PipeWire/PulseAudio)
    ];
  };

  networking.hostName = userSettings.hostname;
}
