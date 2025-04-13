# nixos-config

## Updating configuration

```bash
sudo nixos-rebuild switch -I nixos-config=<path-to-this-repo>/configuration.nix
```

## ZFS setup

Thank you Ivan Petkov for an extensive walkthrough: https://ipetkov.dev/blog/installing-nixos-and-zfs-on-my-desktop/

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

## TPM setup

```
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/disk/by-uuid/<LUKS2 partition>
```

## Issues

Error
```
Traceback (most recent call last):
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 435, in <module>
    main()
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 418, in main
    install_bootloader(args)
  File "/nix/store/mr472bxdbvr41ky92csrdy5gacrklcv9-systemd-boot/bin/systemd-boot", line 342, in install_bootloader
    raise Exception("could not find any previously installed systemd-boot")
Exception: could not find any previously installed systemd-boot
Failed to install bootloader
```

This was solved by running
```
sudo bootctl install
```

and then running the nixos-rebuild command again.