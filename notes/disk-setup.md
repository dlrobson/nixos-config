# Disk Setup Guide

## Drive Setup

Thank you Ivan Petkov for an extensive walkthrough: https://ipetkov.dev/blog/installing-nixos-and-zfs-on-my-desktop/

## HDD Setup

### Initial setup for raidz2

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

### Adding a HDD to the pool
```bash
sudo cryptsetup luksFormat --type luks2 /dev/sda1 
sudo cryptsetup luksAddKey --new-keyfile-size 8192 /dev/sda1 /dev/mapper/cryptkey
sudo cryptsetup luksOpen --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards /dev/sda1 crypthdda
```

## Future Improvements

### Adding another NVME drive to the zfs mirror:
- https://forums.freebsd.org/threads/howto-convert-single-disk-zfs-on-root-to-mirror.49702/
