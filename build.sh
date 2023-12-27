#!/bin/bash

# Define variables
TARGET_DIR="/mnt/debian"  # Change this to your desired target directory
DEBIAN_RELEASE="bullseye"  # Use Bullseye release

# Install debootstrap if not already installed
apt-get update
apt-get install -y debootstrap

# Create the target directory
mkdir -p $TARGET_DIR

# Run debootstrap to install the base system
debootstrap --arch amd64 $DEBIAN_RELEASE $TARGET_DIR

# Mount necessary system directories
mount -o bind /proc $TARGET_DIR/proc
mount -o bind /sys $TARGET_DIR/sys
mount -o bind /dev $TARGET_DIR/dev

# Chroot into the new system
chroot $TARGET_DIR /bin/bash -i

# Now, you are inside the chroot environment

# Update the package lists
apt-get update

# Install essential packages
apt-get install -y vim curl wget git

# Install Flatpak
apt-get install -y flatpak

# Add the Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install applications using Flatpak
flatpak install -y flathub org.gnome.Terminal
flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub org.mozilla.firefox

# Install essential packages using APT
apt-get install -y xorg

# Additional APT packages can be added as needed

# Exit the chroot environment
exit

# Unmount system directories
umount $TARGET_DIR/proc
umount $TARGET_DIR/sys
umount $TARGET_DIR/dev

echo "----------------------------------------"
echo "Debian Bullseye base system with Flatpak installed"
echo "and essential applications installed."
echo "You can now customize your system further."
echo "----------------------------------------"
