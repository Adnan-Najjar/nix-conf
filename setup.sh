#!/usr/bin/env bash
set -euo pipefail

install_docker() {
    if command -v docker &>/dev/null; then
        echo "==> Docker already installed!"
        return 0
    fi

    sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable docker
    echo "==> Docker installed."
}

install_nix() {
    # Install Multi-user Nix if not already present
    if ! command -v nix &> /dev/null; then
        echo "==> Installing Nix..."
        sudo dnf install nix-core nix-devel nix-filesystem nix-daemon nix-legacy nix-libs nix-doc nix-system
    else
        echo "==> Nix is already installed."
    fi
}

main() {
    sudo dnf update -y

    # Update package lists & Install Desktop / Core Tools
    sudo dnf install -y gnome-shell-extensions gnome-shell-extension-gsconnect gnome-tweaks gnome-sushi qalculate-gtk
    sudo dnf install -y virt-manager
    echo "==> Virt-Manager installed."

    sudo dnf install -y fail2ban
    sudo systemctl enable --now fail2ban
    echo "==> Fail2Ban applied."

    install_docker

    # Set up Nix Home-Manager
    install_nix
    echo "==> Setting up Home Manager configuration..."
    nix run nixpkgs#git -- clone https://github.com/adnan-najjar/nix-conf ~/.config/home-manager

    # home-manager switch
    echo "==> Building and applying Home Manager profile..."
    nix run nixpkgs#home-manager -- switch --flake ~/.config/home-manager#adnan

    echo "==> Setup complete!"
}

main
