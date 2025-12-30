#!/bin/zsh

# Install packages
pacman -S --noconfirm stow google-chrome blender discord dust yazi bat kdeconnect hyprmon

echo "Cloning dotfiles"
git clone https://github.com/HamzaHeikal2011/dotfiles.git

# zsh style prompt
read "?Copy dotfiles automatically (y/n): " choice

case "$choice" in
  y|Y)
    echo "Proceeding..."
    cd dotfiles || exit 1
    stow --adopt .
    ;;
  n|N)
    echo "Finishing, Enjoy :)"
    exit 0
    ;;
  *)
    echo "Invalid input"
    exit 1
    ;;
esac
