#!/bin/bash

# EVE-NG Azure Custom Installer
# Author: shaileshBan
# Tested on: Ubuntu 18.04 LTS (Azure VM)

set -e

echo "---------------------------"
echo "EVE-NG Community Installer"
echo "---------------------------"

# Root Check
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

# Update system
apt update && apt upgrade -y

# Fix locale issues (Azure minimal image often has this)
export DEBIAN_FRONTEND=noninteractive
apt install -y locales
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

# Set hostname (optional)
hostnamectl set-hostname eve-ng

# Add i386 architecture for legacy packages
dpkg --add-architecture i386
apt update

# Install required packages
apt install -y \
  software-properties-common \
  bridge-utils ethtool \
  libguestfs-tools \
  genisoimage \
  qemu-kvm \
  libvirt-clients libvirt-daemon-system \
  virtinst libvirt-daemon \
  unzip lsof \
  linux-image-virtual \
  ca-certificates curl gnupg

# Install eve-ng dependencies
apt install -y \
  lib32z1 lib32ncurses5 lib32stdc++6 \
  libguestfs-tools \
  libxt6 libxmu6 \
  libpcap0.8

# Optional: Install GUI (Xfce)
# apt install -y xfce4 xfce4-goodies tightvncserver

# Download and install EVE-NG core packages
mkdir -p /opt/eve-ng
cd /opt/eve-ng

echo "Downloading EVE-NG .deb packages..."
wget http://www.eve-ng.net/repo/installer/install-eve-ng.sh -O install-eve-ng.sh
chmod +x install-eve-ng.sh
./install-eve-ng.sh

# Clean up
apt autoremove -y
echo "Installation complete. Reboot your VM."

