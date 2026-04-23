# pyenv — Python version manager
# https://github.com/pyenv/pyenv
#
# Manages multiple Python versions. Cross-platform (Linux + macOS).
# Uses home-manager's built-in programs.pyenv module for shell integration.
#
# On first activation, installs the latest Python version and sets it as global
# if no versions are installed yet.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/pyenv.nix ];
#   custom.hmPyenv.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmPyenv.enable = lib.mkEnableOption "pyenv Python version manager (auto-installs latest on first activation)";
  };

  config = lib.mkIf config.custom.hmPyenv.enable {
    programs.pyenv = {
      enable = true;
      enableBashIntegration = true;
    };

    # Install latest Python and set as global if no versions are installed yet
    home.activation.pyenvInstallLatest = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v pyenv &>/dev/null; then
        if [ -z "$(pyenv versions --bare 2>/dev/null)" ]; then
          echo "[pyenv] No Python versions found, installing latest..."
          pyenv install --skip-existing "$(pyenv install --list | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')" || echo "[pyenv] Failed to install Python"
          pyenv global "$(pyenv versions --bare | tail -1)" 2>/dev/null || true
          echo "[pyenv] Set global Python to $(pyenv global)"
        fi
      fi
    '';
  };
}
