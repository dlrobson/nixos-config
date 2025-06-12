# Nix Package and NixOS Upgrade Guide

Source: https://discourse.nixos.org/t/how-to-upgrade-packages/6151/9

## Checking and Setting Channels

Check your current subscribed channels:
```bash
sudo nix-channel --list
```

Update to a newer channel (if needed):
```bash
sudo nix-channel --remove nixos
sudo nix-channel --add https://nixos.org/channels/nixos-23.11 nixos
```

## Updating Packages

### Step 1: Update Channel
Pull the latest changes from your subscribed channel:
```bash
sudo nix-channel --update
```

### Step 2: Apply Updates

For NixOS (declarative approach):
```bash
sudo nixos-rebuild switch
```
