# Git — user identity, aliases, and delta diff pager
#
# Configures programs.git with user info derived from userSettings,
# common aliases, and delta for syntax-highlighted diffs.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/git.nix ];
#   custom.git.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.git.enable = lib.mkEnableOption "enables git configuration";
  };

  config = lib.mkIf config.custom.git.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = userSettings.username;
          email = "${userSettings.username}@${userSettings.hostname}";
        };

        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          lg = "log --oneline --graph --decorate --all";
          last = "log -1 HEAD";
          unstage = "reset HEAD --";
          amend = "commit --amend --no-edit";
        };

        init.defaultBranch = "main";
        core.editor = "nano";
        pull.rebase = false;

        # gh auth login writes a credential helper entry after authenticating.
        # Because home-manager manages git config as a read-only nix store symlink,
        # that write fails. Pre-declaring it here avoids the error.
        "credential.https://github.com".helper = "!gh auth git-credential";
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        line-numbers = true;
        navigate = true;
      };
    };
  };
}
