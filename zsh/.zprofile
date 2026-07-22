if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && $(tty) = /dev/tty1 ]]; then
  exec start-hyprland
fi

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
