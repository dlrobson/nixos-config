# nixos-config

My NixOS configuration repository containing system configurations,
home-manager settings, and cross-platform dotfiles. This repository serves as
both documentation and implementation of my reproducible Linux environments.

## Updating configuration

```bash
git clone --recurse-submodules git@github.com:dlrobson/nixos-config.git
cd nixos-config

# Or if you already cloned without submodules
git submodule update --init --recursive

# For NixOS systems, apply the configuration
sudo nixos-rebuild switch -I nixos-config=<path-to-this-repo>/systems/<device-type>/configuration.nix
```

## Documentation

Detailed guides are available in the `notes/` directory.

## Home Directory Management

This repository uses home-manager to provide consistent user environment configuration across different systems and distributions.

### NixOS Systems
On NixOS, home-manager is integrated directly into the system configuration. User environments are managed declaratively alongside system packages and services. Configuration is applied automatically when running `nixos-rebuild switch`.

### Debian/Ubuntu Systems
On Debian-based systems, home-manager runs standalone to manage user dotfiles and packages. The `configure-dotfiles.sh` script handles installation and setup.

Requirements:
- Nix package manager (install from https://nixos.org/download.html)
- The script will set up home-manager if not already installed

To manually apply configuration changes:
```bash
home-manager switch -b backup -f /path/to/this/repo/home.nix
```

## Repository Structure

```
├── systems/          # System-specific NixOS configurations
├── home/             # Home-manager configuration modules
├── scripts/          # Helper scripts for non-NixOS systems
└── notes/            # Documentation and guides
```

## Available Configurations

- **Laptop**: Desktop environment with development tools
- **Server**: Minimal server configuration
- **Home**: Shared home-manager modules

## Non-NixOS Systems

For non-NixOS systems, helper scripts are available:

- [KMonad Setup for Debian](./scripts/debian/kmonad-setup.sh) - Script for
  installing and configuring KMonad on Debian-based systems
- [Configure Dotfiles](./scripts/debian/configure-dotfiles.sh) - Script for
  installing home-manager and deploying dotfiles on Debian-based systems
