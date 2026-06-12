#! /bin/zsh

echo "Congrats: You've passed one of the hardest parts of installing linux. Now to the second part which could either go as smooth as butter or as hard as.... "

echo 'Installing Hyprland Dependencies...'
sudo pacman -S hyprsunset hyprlock hypridle waybar swaync swaybg
echo 'Hyprland dependencies installed.'

echo "Now onto general development stuff..."
sudo pacman -S base-devel nvim yazi ghostty keyd eza zoxide fzf lazygit fd ripgrep

echo "Installing Yay..."
git clone https://aur.archlinux.org/yay.git ~/yay/ 
cd yay && makepkg -si

echo "Installing Tmux Plugin Manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing Zinit for zsh..."
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "Installling fzf-lua for nvim..."
sh -c "$(curl -s https://raw.githubusercontent.com/ibhagwan/fzf-lua/main/scripts/mini.sh)"

echo "Installing elephant and walker..."
yay -S --no-confirm-needed elephant walker
