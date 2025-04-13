# nixos-config

## Manual Machine Configuration

1. Configure ssh-keys + Add to GitHub
2. To allow vscode-server service to run:
```
systemctl --user enable auto-fix-vscode-server.service
systemctl --user start auto-fix-vscode-server.service
```
3. To enable rootless docker
```
systemctl --user enable docker.service
systemctl --user start docker.service
```

## dotfiles

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
# mkdir -p ~/.config/nixpkgs
# ln -s ~/<home-manager-dotfiles-path-TODO> ~/.config/nixpkgs/home.nix
home-manager switch -f ~/.config/nixpkgs/home.nix 
```
