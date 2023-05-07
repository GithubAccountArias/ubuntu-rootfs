#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "No version provided"
  echo "Usage: bootstrap_ubuntu.sh <version> <codename>"
  echo "For example: bootstrap_ubuntu.sh 22.04 jammy"
  exit 1
fi

if [ -z "$2" ]; then
  echo "No codename provided"
  echo "Usage: bootstrap_ubuntu.sh <version> <codename>"
  echo "For example: bootstrap_ubuntu.sh 22.04 jammy"
  exit 1
fi

echo "Making directories"
mkdir -p "/tmp/$1"

echo "Bootstrapping Ubuntu $1 $2"
debootstrap --components=main,restricted,universe,multiverse "$2" /tmp/"$1" http://archive.ubuntu.com/ubuntu

echo "Cleaning rootfs"
# Remove unneeded/temporary files to reduce the rootfs size
rm -rf /tmp/"$1"/boot/*
#rm -rf /tmp/"$1"/dev/*
rm -rf /tmp/"$1"/lost+found/*
rm -rf /tmp/"$1"/media/*
rm -rf /tmp/"$1"/mnt/*
#rm -rf /tmp/"$1"/proc/*
#rm -rf /tmp/"$1"/run/*
#rm -rf /tmp/"$1"/sys/*
rm -rf /tmp/"$1"/tmp/*
rm -rf /tmp/"$1"/var/tmp
#rm -rf /tmp/"$1"/var/cache

echo "Compressing rootfs"
cd "/tmp/$1"
tar -cv -I 'xz -9 -T0' -f ../ubuntu-rootfs-"$1".tar.xz ./

echo "Calculating sha256sum"
# go to where the rootfs is. Using ../ results in broken sha256sum checkfiles
cd ..
sha256sum ubuntu-rootfs-"$1".tar.xz >ubuntu-rootfs-"$1".sha256
