# Visual Studio Code — extensions and settings via home-manager
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/vscode.nix ];
#   custom.vscode.enable = true;

{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.vscode.enable = lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.custom.vscode.enable {
    home.packages = with pkgs; [
      nil # LSP Plugin Support
    ];

    programs.vscode = {
      enable = true;
      profiles.default = {
        userSettings = {
          # Disable update notifications — VS Code is managed by Nix,
          # updates should come through nixos-rebuild, not the built-in updater.
          "update.mode" = "none";
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;

          /*
          "editor.tabSize" = 2;
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "files.trimTrailingWhitespace" = true;
          "files.insertFinalNewline" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll" = "explicit";
            "source.organizeImports" = "explicit";
          };

          "nix.enableLanguageServer" = true;
          # "nix.formatterPath" = "nixfmt"; # LSP Plugin Support
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
              "nix" = {
                "flake" = {
                  autoArchive = true;
                };
              };
            };
          };
          */
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
