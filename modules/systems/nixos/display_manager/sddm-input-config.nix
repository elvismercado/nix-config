# SDDM Input Config — deploy kcminputrc to the SDDM user
# https://wiki.archlinux.org/title/SDDM#Match_Plasma_display_configuration
#
# Copies your KDE Plasma input settings (tap-to-click, touchscreen
# mapping, Wacom tablet settings, mouse acceleration, etc.) to the
# SDDM user's config directory so the Wayland greeter (kwin_wayland)
# inherits them on the login screen.
#
# The source file is typically found at ~/.config/kcminputrc in a
# logged-in Plasma session.
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/display_manager/sddm-input-config.nix
#   ];
#   custom.sysNixSddmInputConfig.enable = true;
#   # Optional: provide a custom kcminputrc file
#   # custom.sysNixSddmInputConfig.kcmInputRc = ../kcminputrc;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixSddmInputConfig.enable = lib.mkEnableOption "deploys input settings (kcminputrc) to the SDDM login screen";

    custom.sysNixSddmInputConfig.kcmInputRc = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a kcminputrc file captured from a logged-in Plasma session
        (typically found at ~/.config/kcminputrc).

        When null (default), the activation script copies the kcminputrc
        from the first real user's home directory if it exists. When set,
        the specified file is deployed instead.
      '';
    };
  };

  config = lib.mkIf config.custom.sysNixSddmInputConfig.enable {
    # Deploy the kcminputrc to the sddm user on every rebuild/activation.
    # This ensures the SDDM Wayland greeter (which uses kwin_wayland)
    # renders with the correct input settings (tap-to-click, Wacom, etc.).
    system.activationScripts.sddmInputConfig = {
      text =
        let
          configFile = config.custom.sysNixSddmInputConfig.kcmInputRc;
        in
        ''
          SDDM_CONFIG="/var/lib/sddm/.config"
          mkdir -p "$SDDM_CONFIG"
          ${
            if configFile != null then
              ''
                cp ${configFile} "$SDDM_CONFIG/kcminputrc"
              ''
            else
              ''
                # Auto-detect: copy from the first user's home directory if available
                for HOME_DIR in /home/*/; do
                  if [ -f "$HOME_DIR.config/kcminputrc" ]; then
                    cp "$HOME_DIR.config/kcminputrc" "$SDDM_CONFIG/kcminputrc"
                    break
                  fi
                done
              ''
          }
          if [ -f "$SDDM_CONFIG/kcminputrc" ]; then
            chown sddm:sddm "$SDDM_CONFIG/kcminputrc"
          fi
        '';
    };
  };
}
