# Console — Linux virtual console (TTY) configuration
# https://wiki.archlinux.org/title/Linux_console
#
# Configures the framebuffer console (Ctrl+Alt+F2–F6): keyboard layout.
#
# Most settings (enable, font, useXkbConfig) are left at NixOS defaults:
#   console.enable       = true   (virtual consoles always available)
#   console.font         = null   (kernel auto-selects; Terminus 32 on ≥2560x1080)
#   console.useXkbConfig = false  (TTY keymap set independently of Xorg/Wayland)
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/system/console.nix ];
#   custom.sysNixConsole.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixConsole.enable = lib.mkEnableOption "Linux virtual console (TTY) keymap configuration";
  };

  config = lib.mkIf config.custom.sysNixConsole.enable {
    console = {
      keyMap = "us";
      # earlySetup = true; # load font/keymap in initrd — only useful if the
      # console is visible during early boot (e.g. LUKS passphrase prompt
      # without Plymouth). With Plymouth hiding the console, this just adds
      # files to the initramfs for no visible benefit.
    };
  };
}
