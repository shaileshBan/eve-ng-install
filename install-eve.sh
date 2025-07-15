#!/bin/bash

# EVE-NG Azure Custom Installer
# Author: shaileshBan

set -e

echo "---------------------------"
echo "EVE-NG Community Installer"
echo "---------------------------"

# Update and prepare system
apt update && apt upgrade -y
export DEBIAN_FRONTEND=noninteractive
apt install -y locales
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

# Add architecture
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

# Install EVE-NG dependencies
apt install -y \
  lib32z1 lib32ncurses5 lib32stdc++6 \
  libguestfs-tools \
  libxt6 libxmu6 \
  libpcap0.8

# Prepare directory
mkdir -p /opt/eve-ng
cd /opt/eve-ng

# Download and run installer
echo "Downloading EVE-NG .deb packages..."
wget https://raw.githubusercontent.com/shaileshBan/eve-ng-install/3d58b664ee1696fe93f725bc231b241072810e02/install-eve.sh -O install-eve-ng.sh
chmod +x install-eve-ng.sh
./install-eve-ng.sh

# Clean up
apt autoremove -y
echo "Installation complete. Reboot your VM."
