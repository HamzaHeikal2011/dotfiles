# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
alias a='arduino-cli'
alias c='clear'
alias neofetch='fastfetch'
alias sba="source .venv/bin/activate"

# overriding omarchy ls defaults
alias ls='eza -lh --group-directories-first --icons=auto --no-user --no-permissions'
alias lsd='eza -lh --group-directories-first --icons=auto'
alias lsda='lsd -a'
alias lt='eza -lh --tree --level=2 --icons --git  --no-user --no-permissions'
alias ltd='eza -lh --tree --level=2 --long --icons --git'
alias ltda='ltd -a'

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

export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/go/bin

# Disabling "Show all resutls.." on hitting esc (for nvim)
shopt -u progcomp
