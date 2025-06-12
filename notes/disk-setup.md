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
- `mountpoint=legacy`: Required for nixos to manage the mount points

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

### Expanding an existing RAIDZ2 vdev

To add a new drive to your existing RAIDZ2 vdev (recommended approach):

1. Format the drive with LUKS2:

```bash
sudo cryptsetup luksFormat --type luks2 /dev/sdc1
```

2. Add a keyfile for automatic unlocking:

```bash
sudo cryptsetup luksAddKey --new-keyfile-size 8192 /dev/sdc1 /dev/mapper/cryptkey
```

3. Open the encrypted drive:

```bash
sudo cryptsetup luksOpen --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards /dev/sdc1 crypthddf
```

4. Enable RAIDZ expansion feature (if not already enabled):

```bash
sudo zpool set feature@raidz_expansion=enabled hdd-pool
```

5. Attach the new drive to expand the existing RAIDZ2 vdev:

```bash
sudo zpool attach hdd-pool raidz2-0 /dev/mapper/crypthddf
```

6. Monitor expansion progress:

```bash
sudo zpool status hdd-pool
```

**Why use `zpool attach` instead of `zpool add`?**
- Maintains consistent RAIDZ2 redundancy across all data
- Better space efficiency compared to mixed vdev types
- Avoids creating unbalanced pool with different redundancy levels

### Adding a new vdev to the pool

Alternatively, you can add drives as new vdevs (creates striped configuration):

```bash
# Add as single drive (not recommended - no redundancy)
sudo zpool add hdd-pool /dev/mapper/crypthddf

# Add as new RAIDZ2 vdev (requires 3+ drives)
sudo zpool add hdd-pool raidz2 /dev/mapper/crypthddf /dev/mapper/crypthddg /dev/mapper/crypthddh
```

**Cryptsetup options explained:**
- `--type luks2`: Uses the newer, more secure LUKS format
- `--keyfile-size 8192`: Uses a larger key for better security
- `--allow-discards`: Permits TRIM/discard operations through the encryption layer, improving SSD performance and longevity, though with minor security implications

## NVME Pool Mirror Setup

### Converting single NVME to mirror

To convert your single-drive NVME root pool to a mirrored configuration:

1. Upgrade pool features:

```bash
# Enable all ZFS features
sudo zpool upgrade nvme-pool
```

2. Prepare the second NVME drive:

```bash
# Format with LUKS2
sudo cryptsetup luksFormat --type luks2 /dev/nvme1n1

# Add keyfile (use same keyfile as original drive)
sudo cryptsetup luksAddKey --new-keyfile-size 8192 /dev/nvme1n1 /dev/mapper/cryptkey

# Open encrypted drive
sudo cryptsetup luksOpen --keyfile-size 8192 --key-file /dev/mapper/cryptkey --allow-discards /dev/nvme1n1 cryptroot2
```

3. Attach to create mirror:

```bash
# Convert single drive to mirror (use the actual device name from zpool status)
sudo zpool attach nvme-pool dm-uuid-CRYPT-LUKS2-40edc509941a4bbda43686ec9703fc18-cryptroot /dev/mapper/cryptroot2
```

4. Monitor resilver progress:

```bash
# Check resilver status
sudo zpool status nvme-pool
```

## Useful Commands

### Checking pool status and expansion progress

```bash
# Check pool status and expansion progress
sudo zpool status hdd-pool

# List all pool features
sudo zpool upgrade -v hdd-pool

# Check specific feature status
sudo zpool get all hdd-pool | grep raidz_expansion
```
