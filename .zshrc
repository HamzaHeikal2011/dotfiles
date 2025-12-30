# ~/.zshrc

# CRUCIAL
bindkey -v
eval "$(sheldon source)"
source .local/share/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# addons
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Aliases:
alias a='arduino-cli'
alias c='clear'
alias neofetch='fastfetch'
alias sba="source .venv/bin/activate"
alias '..'='cd ..'
alias '...'='cd ...'
alias '....'='cd ....'

# overriding omarchy ls defaults
alias ls='eza -lh --group-directories-first --icons=auto --no-user --no-permissions'
alias lsa='ls -a'
alias lsd='eza -lh --group-directories-first --icons=auto'
alias lsda='lsd -a'
alias lt='eza -lh --tree --level=2 --icons --git  --no-user --no-permissions'
alias lta='lt -a'
alias ltd='eza -lh --tree --level=2 --long --icons --git'
alias ltda='ltd -a'

# functions

## Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
