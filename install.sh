#! /bin/zsh

echo "Congrats: You've passed one of the hardest parts of installing linux. Now to the second part which could either go as smooth as butter or as hard as.... "

echo 'Installing Hyprland Dependencies...'
sudo pacman -S uwsm hyprsunset hyprlock hypridle waybar swaync swaybg
echo 'Hyprland dependencies installed.'

echo "Now onto general development stuff..."
sudo pacman -S base-devel 
