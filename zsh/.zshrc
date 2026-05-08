# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Starship
eval "$(starship init zsh)"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='eza -lh --group-directories-first --icons=auto --no-user --no-permissions'
alias lsa='ls -a'
alias lsd='eza -lh --group-directories-first --icons=auto'
alias lsda='lsd -a'
alias lt='eza -lh --tree --level=2 --icons --git  --no-user --no-permissions'
alias lta='lt -a'
alias ltd='eza -lh --tree --level=2 --long --icons --git'
alias ltda='ltd -a'
alias vim='nvim'
alias c='clear'
alias jet='openclaw'
alias jett='openclaw tui'
alias disk='udiskie'
alias 'disku'='udiskie-umount -a'
alias lg="lazygit"
alias t='tmux'
alias '..'='cd ..'
alias '...'='cd ...'
alias '....'='cd ....'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
export PATH="/home/hamza/.local/share/mise/installs/node/25.1.0/bin:$PATH"
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# OpenClaw Completion
source "/home/hamza/.openclaw/completions/openclaw.zsh"
