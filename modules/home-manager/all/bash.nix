# Bash shell configuration — history, completions, initExtra
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/bash.nix ];
#   custom.bash.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.bash.enable = lib.mkEnableOption "enables bash";
  };

  config = lib.mkIf config.custom.bash.enable {
    # ── Bash shell lifecycle hooks ──────────────────────────────────────
    #
    # Home-manager generates three bash config files from these hooks:
    #
    #   ~/.bash_profile  ← profileExtra        (login shells only)
    #   ~/.bashrc        ← bashrcExtra, then   (interactive shells)
    #                      initExtra
    #   ~/.bash_logout   ← logoutExtra         (login shells on exit)
    #
    # bashrcExtra and initExtra both write to .bashrc —
    # bashrcExtra runs first (raw content), initExtra runs after.
    #
    # ── Which hooks run in each scenario ────────────────────────────────
    #
    #   Scenario                          profileExtra  bashrcExtra  initExtra  logoutExtra
    #   ─────────────────────────────────────────────────────────────────────────────────────
    #   macOS Terminal.app / iTerm2       ✓ (1st)       ✓ (2nd)      ✓ (3rd)    ✓ on exit
    #   SSH session                       ✓ (1st)       ✓ (2nd)      ✓ (3rd)    ✓ on exit
    #   Linux terminal (Konsole, GNOME)   ✗             ✓ (1st)      ✓ (2nd)    ✗
    #   Subshell (`bash` inside bash)     ✗             ✓ (1st)      ✓ (2nd)    ✗
    #   Non-interactive (`bash -c "cmd"`) ✗             ✗            ✗          ✗
    #   Closing terminal / `exit`         —             —            —          ✓ (login only)
    #
    # macOS Terminal.app and SSH open login + interactive shells, so all
    # hooks fire. Linux terminal emulators typically open interactive-only
    # shells (no login), so profileExtra and logoutExtra are skipped.
    #
    programs.bash = {
      enable = true; # required for home.shellAliases to work
      bashrcExtra = "echo 'Hello ${userSettings.hostname} (bashrc)'";
      historyFileSize = 100000;
      initExtra = ''
        command -v fastfetch &>/dev/null && fastfetch
        echo 'Hello ${userSettings.hostname} (interactive)'
      '';
      logoutExtra = "echo 'Goodbye ${userSettings.hostname} (logout)'";
      profileExtra = "echo 'Hello ${userSettings.hostname} (login)'";
      sessionVariables = { };
      shellAliases = {
      };
      # shellOptions = [];
    };
  };
}
