#!/bin/sh
set -eu

# Private helper functions
_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_home_manager() {
    if _command_exists home-manager; then
        echo "home-manager is already installed."
        return 0
    fi

    echo "Installing home-manager..."

    if ! nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager; then
        echo "Error: Failed to add home-manager channel"
        return 1
    fi

    if ! nix-channel --update; then
        echo "Error: Failed to update channels"
        return 1
    fi

    # Install home-manager
    if ! nix-shell '<home-manager>' -A install; then
        echo "Error: Failed to install home-manager"
        return 1
    fi

    # Validate installation
    if ! _command_exists home-manager; then
        echo "Error: home-manager installation failed"
        return 1
    fi

    return 0
}

deploy_home_manager() {
    echo "Deploying home-manager configuration..."
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    REPO_ROOT=$(dirname "$(dirname "$SCRIPT_DIR")")
    
    # Deploy home-manager configuration. Replace conflicting files with .backup
    if ! home-manager switch -b backup -f "$REPO_ROOT/home.nix"; then
        echo "Error: Failed to apply home-manager configuration"
        return 1
    fi
    
    return 0
}

main() {
    if ! _command_exists nix; then
        echo "Error: Nix is required but not installed."
        echo "Please install Nix first: https://nixos.org/download.html"
        echo "After installing Nix, run this script again."
        exit 1
    fi

    if ! install_home_manager; then
        echo "Failed to install home-manager"
        exit 1
    fi

    if ! deploy_home_manager; then
        echo "Failed to deploy home-manager"
        exit 1
    fi
    
    echo "Home-manager setup and configuration complete! Please ensure either bash or fish is your default shell."
}

main
