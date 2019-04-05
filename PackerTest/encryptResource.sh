#!/usr/bin/env bash

# Generate key for encryption
mkdir -p /key
mount -t tmpfs -o size=2M none /key
dd if=/dev/random of=/key/keyfile bs=1024 count=4

# Encrypt the device
cryptsetup luksFormat /dev/sdb1 /key/keyfile -q
cryptsetup luksOpen /dev/sdb1 resource --key-file /key/keyfile

# Create filesystem on device and mount
mkfs.ext4 /dev/mapper/resource
mount /dev/mapper/resource /mnt/resource/
