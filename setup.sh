#!/usr/bin/env bash
set -euo pipefail

install_docker() {
    # Add Docker's official GPG key:
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "==> Docker installed."
}

install_nix() {
    # Install Multi-user Nix if not already present
    if ! command -v nix &> /dev/null; then
        echo "==> Installing Nix..."
        installer="$(mktemp)"
        cleanup() {
            rm -f "$installer"
        }
        trap cleanup EXIT

        curl --proto '=https' --tlsv1.2 -fsSL \
          -o "$installer" \
          https://nixos.org/nix/install

        # Run the multi-user installer non-interactively
        bash "$installer" --daemon --yes
        
        # CRITICAL: Force load the new paths into this running bash environment
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
    else
        echo "==> Nix is already installed."
    fi

    # Configure Nix Experimental Features (Flakes) safely
    mkdir -p ~/.config/nix
    if ! grep -q "flakes" ~/.config/nix/nix.conf 2>/dev/null; then
        echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
    fi
    echo "==> Nix configured."
}

main() {
    sudo apt update

    # Update package lists & Install Desktop / Core Tools
    sudo apt install -y --no-install-recommends vanilla-gnome-desktop
    sudo apt install -y gnome-shell-extension-gsconnect gnome-tweaks gnome-sushi qalculate-gtk
    echo "==> GNOME installed."

    sudo apt install -y virt-manager
    echo "==> Virt-Manager installed."

    sudo apt install -y fail2ban
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

    # Electron apps fix
    echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee /etc/sysctl.d/99-nix-electron.conf
    sudo sysctl --system

    echo "==> Setup complete!"
    while ! sudo systemctl start display-manager.service; do
        echo "Display manager failed to start. Retrying in 2 seconds..."
        sleep 2
    done
}

main
