# SDDM — Simple Desktop Display Manager
# https://wiki.archlinux.org/title/SDDM
#
# Enables the SDDM display manager with Wayland greeter (kwin_wayland),
# Breeze cursor theme, NumLock on, virtual keyboard, and layer-shell
# integration for proper Wayland greeter rendering.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.sysNixSddm.enable = lib.mkEnableOption "enables SDDM display manager";
  };

  config = lib.mkIf config.custom.sysNixSddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true; # use kwin_wayland — respects kwinoutputconfig.json primary monitor
      settings = {
        General = {
          Numlock = "on";
          # NOTE: do NOT set InputMethod here — it breaks the Wayland KWin
          # greeter. Virtual keyboard is configured via --inputmethod in
          # CompositorCommand below.
          # https://wiki.archlinux.org/title/SDDM#Virtual_keyboards
        };
        Theme = {
          # Use the Breeze cursor on the login screen instead of the
          # default Adwaita cursor that can appear on KDE setups.
          # https://wiki.archlinux.org/title/SDDM#Mouse_cursor
          CursorTheme = "breeze_cursors";
        };
        Wayland = {
          # Pass --inputmethod to kwin_wayland so the virtual keyboard works
          # on the Wayland greeter. Setting InputMethod in [General] does NOT
          # work with KWin and causes the keyboard to never appear.
          # https://wiki.archlinux.org/title/SDDM#Virtual_keyboards
          CompositorCommand = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1 --inputmethod qtvirtualkeyboard";
        };
        Environment = {
          LANG = "en_GB.UTF-8";
          # Ensure the Wayland greeter uses layer-shell for proper
          # rendering with KWin compositor.
          # https://wiki.archlinux.org/title/SDDM#KDE_Plasma_/_KWin
          QT_WAYLAND_SHELL_INTEGRATION = "layer-shell";
        };
      };
      # Required for the virtual keyboard on the SDDM login screen.
      extraPackages = [
        pkgs.kdePackages.qtvirtualkeyboard
      ];
    };
  };
}
