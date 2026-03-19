#!/bin/bash

# Install packages
pacman -S --noconfirm stow google-chrome blender discord dust yazi bat kdeconnect hyprmon

echo "Cloning dotfiles"
git clone https://github.com/HamzaHeikal2011/dotfiles.git

read -p "Copy dotfiles automatically (y/N): " choice

case "$choice" in
y | Y)
  echo "Proceeding..."
  # Assuming the dotfiles repo contains a .config folder
  cd dotfiles || exit 1
  stow --adopt .
  ;;
N)
  echo "Finishing, Enjoy :)"
  exit 0
  ;;
*)
  echo "Invalid input"
  exit 1
  ;;
esac
