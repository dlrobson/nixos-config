# Disk Setup Guide

## Introduction

This guide explains the ZFS storage setup process for NixOS. Credit to [Ivan Petkov](https://ipetkov.dev/blog/installing-nixos-and-zfs-on-my-desktop/) for the original walkthrough.

## HDD Pool Setup (RAIDZ2)

### 1. Create the ZFS pool with RAIDZ2

Create a RAIDZ2 pool using 5 encrypted drives:

```bash
sudo zpool create hdd-pool raidz2 \
  /dev/mapper/crypthdda \
  /dev/mapper/crypthddb \
  /dev/mapper/crypthddc \
  /dev/mapper/crypthddd \
  /dev/mapper/crypthdde
```

### 2. Configure pool properties

Set basic pool properties:

```bash
sudo zfs set mountpoint=none hdd-pool
sudo zfs set compression=lz4 hdd-pool
sudo zfs set atime=off hdd-pool
```

**Why these settings?**
- `mountpoint=none`: Prevents the pool's root from being mounted, as we'll mount specific datasets instead
- `compression=lz4`: Enables LZ4 compression which offers an excellent balance between compression ratio and CPU usage
- `atime=off`: Disables access time updates, significantly reducing disk writes and improving performance

### 3. Create datasets

Create datasets for different types of data:

```bash
sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/data
sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/media
```

**Why legacy mountpoints?**
- `mountpoint=legacy`: Requied for nixos to manage the mount points

### 4. Create reserved space

Reserve space to prevent pool from filling completely:

```bash
sudo zfs create -o compression=lz4 -o mountpoint=legacy hdd-pool/reserved
sudo zfs set quota=500G hdd-pool/reserved
sudo zfs set reservation=500G hdd-pool/reserved
```

**Why reserved space?**
- ZFS performance degrades significantly when pools approach full capacity
- Reserved space guarantees the pool will never completely fill up

### 5. Mount the datasets

Create mount points and mount the datasets:

```bash
sudo mkdir -p /mnt/storage/{data,media}
sudo mount -t zfs hdd-pool/data /mnt/storage/data
sudo mount -t zfs hdd-pool/media /mnt/storage/media
```

## Adding New Disks

### Adding a new encrypted HDD to the pool

1. Format the drive with LUKS2:

```bash
sudo cryptsetup luksFormat --type luks2 /dev/sda1
```

2. Add a keyfile for automatic unlocking:

```bash
sudo cryptsetup luksAddKey --new-keyfile-size 8192 /dev/sda1 /dev/mapper/cryptkey
```

3. Open the encrypted drive:

```bash
sudo cryptsetup luksOpen --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards /dev/sda1 crypthdda
```

**Why these cryptsetup options?**
- `--type luks2`: Uses the newer, more secure LUKS format
- `--keyfile-size 8192`: Uses a larger key for better security
- `--allow-discards`: Permits TRIM/discard operations through the encryption layer, improving SSD performance and longevity, though with minor security implications

4. Add the opened device to your pool (not shown - use zpool add command)

## Future Improvements

### Adding another NVME drive to create a ZFS mirror

For converting a single-disk ZFS root to a mirror, refer to:
- [FreeBSD Forum Guide](https://forums.freebsd.org/threads/howto-convert-single-disk-zfs-on-root-to-mirror.49702/)
