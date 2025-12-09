# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
alias a='arduino-cli'
alias amon='arduino-cli monitor -p /dev/ttyACM0'
alias c='clear'
alias arduino-ide='exec ~/Desktop/3-resources/appimages/Arduino.AppImage'
alias logseq='exec ~/Downloads/Logseq.AppImage'
alias neofetch='fastfetch'

# Yazi "cd" replacement
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Defaults:
export EDITOR=nvim
export VISUAL=nvim

# uv
export PATH="/home/hamza/.local/share/../bin:$PATH"

