#!/bin/bash

pacman -S stow chrome exfat-utils pacman blender pacman discord dust yazi bat

echo  "cloning dotfiles"
git clone https://github.com/HamzaHeikal2011/dotfiles.git

read -p "Copy dotfiles automaticaly? (y/n): "
case "$choice" in
  y|Y )
    echo "Proceeding..."
    sudo cp ./.config ~/.config
    ;;
  n|N )
    echo "Finishing, Enjoy :)"
    exit 0 # Exit the script if not confirmed

