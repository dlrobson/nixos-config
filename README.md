# nixos-config

My NixOS configuration repository containing system configurations,
home-manager settings, and cross-platform dotfiles. This repository serves as
both documentation and implementation of my reproducible Linux environments.

## Updating configuration

```bash
sudo nixos-rebuild switch -I nixos-config=<path-to-this-repo>/systems/laptop/configuration.nix
```

## Documentation

Detailed guides are available in the `notes/` directory.

## Dotfiles Implementation

### NixOS Systems
On NixOS, dotfiles are managed through the native system configuration and
home-manager module. The configuration is applied automatically when running
`nixos-rebuild switch`.

The home manager configuration is imported in each system's configuration.nix file:

```nix
# Inside systems/laptop/configuration.nix or systems/server/configuration.nix
home-manager.users.username = import ../../home {
  username = "username";
  homeDirectory = "/home/username";
  inherit config pkgs lib;
};
```

### Debian/Ubuntu Systems
On Debian-based systems, dotfiles are managed using standalone home-manager.
The `configure-dotfiles.sh` script:
1. Requires the Nix package manager to be pre-installed (install from
   https://nixos.org/download.html)
2. Sets up home-manager through nix channels if not already installed
3. Deploys the dotfiles configuration from this repository

To manually apply the dotfiles configuration after changes, run:
```bash
home-manager switch -b backup -f /path/to/this/repo/home.nix
```

This approach ensures consistent configuration across different Linux
distributions while using the same underlying home-manager technology.

## Non-NixOS Systems

For non-NixOS systems, helper scripts are available:

- [KMonad Setup for Debian](./scripts/debian/kmonad-setup.sh) - Script for
  installing and configuring KMonad on Debian-based systems
- [Configure Dotfiles](./scripts/debian/configure-dotfiles.sh) - Script for
  installing home-manager and deploying dotfiles on Debian-based systems
