# Finder — macOS Finder appearance and behavior
#
# Configures system.defaults.finder with view style, search scope,
# path/status bars, sorting, desktop icons, and trash policy.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/finder.nix ];
#   custom.sysDarFinder.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarFinder.enable = lib.mkEnableOption "macOS Finder view, sidebar, sorting, and trash policy";
  };

  config = lib.mkIf config.custom.sysDarFinder.enable {
    system.defaults.finder = {
      # View
      FXPreferredViewStyle = "clmv"; # Column view
      _FXEnableColumnAutoSizing = true;

      # Navigation
      NewWindowTarget = "Home";
      FXDefaultSearchScope = "SCcf"; # Search current folder

      # Bars
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;

      # Files & extensions
      AppleShowAllFiles = false;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;

      # Sorting
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;

      # Desktop
      CreateDesktop = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowHardDrivesOnDesktop = false;

      # Behavior
      QuitMenuItem = true;
      FXRemoveOldTrashItems = true;
    };
  };
}
