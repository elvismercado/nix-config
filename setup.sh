#!/bin/sh
set -e

REPO_NAME="nix-config"
REPO_DIR="$HOME/git/$REPO_NAME"

get_os_name() {
  [ -f /etc/os-release ] || return 1
  awk -F= '/^ID=/{gsub(/"/, "", $2); print $2}' /etc/os-release
}

get_os_type() {
  OS_TYPE=$(uname)

  if [ "$OS_TYPE" = "Linux" ]; then
    echo "[Setup] Linux detected"
    OS_NAME=$(get_os_name)
    echo "[Setup] OS is $OS_NAME"

    if grep -qi NixOS /etc/os-release 2>/dev/null; then
      echo "[Setup nixos] NixOS detected"
      echo "[Setup nixos] Add the following to '/etc/nixos/configuration.nix'"
      echo "[Setup nixos] 'nix.settings.experimental-features = [ \"nix-command\" \"flakes\" ];'"
      echo "[Setup nixos] run 'sudo nixos-rebuild switch' after"
    fi
  elif [ "$OS_TYPE" = "Darwin" ]; then
    echo "[Setup] Darwin detected"
  else
    echo "[Setup] Not on Linux or Darwin"
  fi
}

is_nix_installed() {
  command -v nix >/dev/null 2>&1
}

source_nix() {
  # Source Nix profile so nix/nix-shell are available in this session
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
}

run_determinite_installer() {
  # Determinate Nix Installer (with flakes enabled by default)
  #
  # Why? Because it will install Nix package manager allowing us to use packages
  # without installing them and help with the rest of the setup
  #
  # https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#installation
  #
  # `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate`

  if is_nix_installed; then
    echo "[Setup] Nix already installed, skipping installer"
    return 0
  fi

  echo "[Setup] Running the Determinate installer"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate

  # Make nix available in this shell session
  source_nix
}

install_xcode_clt() {
  # Xcode Command Line Tools (required for git, compilers, Homebrew, pyenv, etc.)
  # Only needed on macOS — skips if already installed.

  if [ "$(uname)" != "Darwin" ]; then
    return 0
  fi

  if /usr/bin/xcode-select -p >/dev/null 2>&1; then
    echo "[Setup] Xcode Command Line Tools already installed, skipping"
    return 0
  fi

  echo "[Setup] Installing Xcode Command Line Tools..."
  /usr/bin/xcode-select --install

  # Wait for installation to complete (the installer runs in the background)
  echo "[Setup] Waiting for Xcode CLT installation to complete..."
  local max_attempts=180 # 15 minutes (180 × 5s)
  local attempt=0
  until /usr/bin/xcode-select -p >/dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "[Setup] ERROR: Timed out waiting for Xcode CLT installation (15 minutes)."
      echo "[Setup] Install manually with: xcode-select --install"
      exit 1
    fi
    sleep 5
  done
  echo "[Setup] Xcode Command Line Tools installed"
}

install_homebrew() {
  # Homebrew package manager (required for nix-darwin's homebrew module)
  # Only needed on macOS — skips if already installed.
  # https://brew.sh

  if [ "$(uname)" != "Darwin" ]; then
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "[Setup] Homebrew already installed, skipping"
    return 0
  fi

  echo "[Setup] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for this session
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  echo "[Setup] Homebrew installed"
}

download_repo() {
  mkdir -p ~/git

  # Authenticate with GitHub if not already logged in
  if nix-shell -p gh --run "gh auth status" >/dev/null 2>&1; then
    echo "[Setup] Already authenticated with GitHub"
  else
    echo "[Setup] Logging in to GitHub..."
    nix-shell -p gh --run "gh auth login"
  fi

  if [ -d "$REPO_DIR" ]; then
    echo "[Setup] Repo already exists at $REPO_DIR, pulling latest..."
    nix-shell -p git --run "git -C '$REPO_DIR' pull"
  else
    echo "[Setup] Cloning repo to $REPO_DIR..."
    nix-shell -p gh --run "gh repo clone elvismercado/nix-config '$REPO_DIR'"
  fi

  echo "[Setup] Ready to use nix-config"
}

# Start
echo "[Setup] Starting script..."

get_os_type

# Install this first! (if not on NixOS)
run_determinite_installer

# Ensure nix is available (may already be installed from a previous run)
source_nix

# macOS prerequisites (idempotent — skipped on Linux)
install_xcode_clt
install_homebrew

download_repo
