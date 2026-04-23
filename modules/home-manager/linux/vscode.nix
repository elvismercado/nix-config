# Visual Studio Code — extensions and settings via home-manager
#
# Usage:
#   imports = [ ../../../modules/home-manager/linux/vscode.nix ];
#   custom.hmVscode.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.hmVscode.enable = lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.custom.hmVscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        userSettings = {
          # Disable update notifications — VS Code is managed by Nix,
          # updates should come through nixos-rebuild, not the built-in updater.
          "update.mode" = "none";
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;
        };

        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide # Nix support
          eamodio.gitlens # GitLens
          esbenp.prettier-vscode # Prettier formatter
        ];
        
      };
    };
  };
}
