#!/bin/zsh
# =============================================================================
# Dotfiles Auto Initializer
# =============================================================================

# --- Colors ------------------------------------------------------------------
autoload -U colors && colors
info()    { echo "${fg[cyan]}[INFO]${reset_color}  $1" }
success() { echo "${fg[green]}[OK]${reset_color}    $1" }
warn()    { echo "${fg[yellow]}[WARN]${reset_color}  $1" }
error()   { echo "${fg[red]}[ERR]${reset_color}   $1" }

# --- Stow helper -------------------------------------------------------------
# Usage: stow_pkg <target-to-remove> <stow-package> [is-file]
stow_pkg() {
  local target="$1"
  local pkg="$2"
  local is_file="${3:-false}"

  info "Stowing $pkg → $target"

  if [[ "$is_file" == "true" ]]; then
    rm -f "$target"
  else
    rm -rf "$target"
  fi

  if stow "$pkg" 2>/dev/null; then
    success "$pkg"
  else
    error "Failed to stow $pkg"
    FAILED+=("$pkg")
  fi
}

# --- Main --------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Auto Machine Initializer           ║"
echo "╚══════════════════════════════════════╝"
echo ""

read "?Copy dotfiles automatically? (y/N): " choice

case "$choice" in
  y|Y)
    info "Proceeding with dotfiles setup..."
    echo ""

    cd dotfiles || { error "Could not find dotfiles directory"; exit 1 }

    typeset -a FAILED

    stow_pkg ~/.bashrc              bash        true
    stow_pkg ~/.config/fontconfig   fontconfig
    stow_pkg ~/.config/ghostty      ghostty
    stow_pkg ~/.config/hypr         hypr
    stow_pkg ~/.config/nvim         nvim
    stow_pkg ~/.config/starship.toml starship   true
    stow_pkg ~/.config/swaync       swaync
    stow_pkg ~/.config/swayosd      swayosd
    stow_pkg ~/.local/share/omarchy/themes/graphite-black theme
    stow_pkg ~/.config/tmux         tmux
    stow_pkg ~/.config/walker       walker
    stow_pkg ~/.config/waybar       waybar
    stow_pkg ~/.config/yazi         yazi
    stow_pkg ~/.zshrc               zsh         true

    echo ""

    # Summary
    if (( ${#FAILED[@]} == 0 )); then
      success "All packages stowed successfully!"
    else
      error "The following packages failed to stow:"
      for pkg in "${FAILED[@]}"; do
        echo "  • $pkg"
      done
    fi

    echo ""
    warn "ACTION REQUIRED: Walker config needs manual update."
    warn "Go to: ~/.local/share/omarchy/default/walker/themes/omarchy-default/"
    warn "and replace your files there."
    echo ""
    ;;

  n|N|"")
    echo ""
    success "Aborted. Enjoy :)"
    exit 0
    ;;

  *)
    error "Invalid input: '$choice'. Expected y or N."
    exit 1
    ;;
esac
