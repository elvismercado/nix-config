{
  username = "fennec"; # username or name of the system user
  hostname = "FENNEC"; # as description or hostname
  system = "x86_64-linux";
  channel = "stable"; # "stable" or "unstable"
  timeZone = "Europe/Amsterdam";
  uid = 1000; # UID for the system user — must match install script chown
  repoPath = "git/nix-config"; # relative to $HOME
  desktopEnvironment = "kde-plasma"; # "kde-plasma", "cosmic", etc.
}
