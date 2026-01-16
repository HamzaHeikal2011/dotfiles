# ~/.zshrc

# --------------------- #

# plugins manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit
zinit cdreplay -q
# --------------------- #

# addons
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"
export BAT_THEME=ansi

# --------------------- #

bindkey -v
# history config 
bindkey '^k' history-search-backward
bindkey '^j' history-search-forward

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --------------------- #

# zsh-autocomplete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --------------------- #

# Aliases:
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias c='clear'
alias vim='nvim'
alias vi='nvim'
alias sba="source .venv/bin/activate"
alias lg="lazygit"
alias '..'='cd ..'
alias '...'='cd ...'
alias '....'='cd ....'

# better ls
alias ls='eza -lh --group-directories-first --icons=auto --no-user --no-permissions'
alias lsa='ls -a'
alias lsd='eza -lh --group-directories-first --icons=auto'
alias lsda='lsd -a'
alias lt='eza -lh --tree --level=2 --icons --git  --no-user --no-permissions'
alias lta='lt -a'
alias ltd='eza -lh --tree --level=2 --long --icons --git'
alias ltda='ltd -a'

# --------------------- #

# functions

## Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# --------------------- #

# alt bin sources
## go
export PATH=$PATH:$HOME/.local/opt/go/bin

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
