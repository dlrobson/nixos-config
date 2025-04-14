# nixos-config

## Updating configuration

```bash
sudo nixos-rebuild switch -I nixos-config=<path-to-this-repo>/configuration.nix
```

## ZFS setup

Thank you Ivan Petkov for an extensive walkthrough: https://ipetkov.dev/blog/installing-nixos-and-zfs-on-my-desktop/

### Hdd Setup

#### Initial setup for raidz2

```bash
sudo zpool create hdd-pool raidz2 \
  /dev/mapper/crypthdda \
  /dev/mapper/crypthddb \
  /dev/mapper/crypthddc \
  /dev/mapper/crypthddd \
  /dev/mapper/crypthdde
sudo zfs set mountpoint=none hdd-pool
sudo zfs set compression=lz4 hdd-pool
sudo zfs set atime=off hdd-pool
sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/data
sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/media

sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/reserved
sudo zfs set quota=500G hdd-pool/reserved
sudo zfs set reservation=500G hdd-pool/reserved

sudo mkdir -p /mnt/storage/{data,media}
sudo mount -t zfs hdd-pool/data /mnt/storage/data
sudo mount -t zfs hdd-pool/media /mnt/storage/media
```

#### Adding a HDD to the pool
```bash
sudo cryptsetup luksFormat --type luks2 /dev/sda1 
sudo cryptsetup luksAddKey --new-keyfile-size 8192 /dev/sda1 /dev/mapper/cryptkey
sudo cryptsetup luksOpen --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards /dev/sda1 crypthdda
```

## Manual Machine Configuration

1. Configure ssh-keys + Add to GitHub
2. To allow vscode-server service to run:
```
systemctl --user start auto-fix-vscode-server.service
```
3. To enable rootless docker
```
systemctl --user enable docker.service
systemctl --user start docker.service
```

## dotfiles (TODO)

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
# mkdir -p ~/.config/nixpkgs
# ln -s ~/<home-manager-dotfiles-path-TODO> ~/.config/nixpkgs/home.nix
home-manager switch -f ~/.config/nixpkgs/home.nix 
```

## TPM setup

Enroll the TPM2 chip with the LUKS2 partition. This is required for unlocking the LUKS2 partition at boot time.

```
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/disk/by-uuid/<LUKS2 partition>
```

## Future

1. Add another NVME drive to the zfs mirror:
  - https://forums.freebsd.org/threads/howto-convert-single-disk-zfs-on-root-to-mirror.49702/

## Potential Issues

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