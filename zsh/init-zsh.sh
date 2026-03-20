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

# --- Dotfiles directory resolver ---------------------------------------------
find_dotfiles_dir() {
  local candidates=()

  # Check if we're already inside a dotfiles dir
  local cwd
  cwd="$(pwd)"
  local cwd_base
  cwd_base="$(basename "$cwd")"

  if [[ "$cwd_base" == "dotfiles" || "$cwd_base" == ".dotfiles" ]]; then
    candidates+=("$cwd (current directory)")
  fi

  # Check home directory
  [[ -d "$HOME/dotfiles"  && "$cwd" != "$HOME/dotfiles"  ]] && candidates+=("$HOME/dotfiles")
  [[ -d "$HOME/.dotfiles" && "$cwd" != "$HOME/.dotfiles" ]] && candidates+=("$HOME/.dotfiles")

  if (( ${#candidates[@]} == 0 )); then
    error "No dotfiles directory found (checked ~/dotfiles and ~/.dotfiles)"
    exit 1
  fi

  if (( ${#candidates[@]} == 1 )); then
    # Strip the "(current directory)" label if present
    DOTFILES_DIR="${candidates[1]% \(current directory\)}"
    info "Found dotfiles directory: $DOTFILES_DIR"
    read "?Is this correct? (y/N): " confirm
    [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { warn "Aborted by user."; exit 0 }
  else
    echo ""
    info "Multiple dotfiles directories found. Please select one:"
    echo ""
    for i in {1..${#candidates[@]}}; do
      echo "  [$i] ${candidates[$i]}"
    done
    echo "  [0] None of these — abort"
    echo ""
    read "?Enter choice: " sel
    if [[ "$sel" == "0" ]]; then
      warn "Aborted by user."; exit 0
    elif [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= ${#candidates[@]} )); then
      DOTFILES_DIR="${candidates[$sel]% \(current directory\)}"
    else
      error "Invalid selection."
      exit 1
    fi
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

    find_dotfiles_dir
    echo ""
    info "Using: $DOTFILES_DIR"
    cd "$DOTFILES_DIR" || { error "Could not cd into $DOTFILES_DIR"; exit 1 }

    typeset -a FAILED

    stow_pkg ~/.bashrc                 bash        true
    stow_pkg ~/.config/fontconfig      fontconfig
    stow_pkg ~/.config/ghostty         ghostty
    stow_pkg ~/.config/hypr            hypr
    stow_pkg ~/.config/nvim            nvim
    stow_pkg ~/.config/starship.toml   starship    true
    stow_pkg ~/.config/swaync          swaync
    stow_pkg ~/.config/swayosd         swayosd
    stow_pkg ~/.local/share/omarchy/themes/graphite-black theme
    stow_pkg ~/.config/tmux            tmux
    stow_pkg ~/.config/walker          walker
    stow_pkg ~/.config/waybar          waybar
    stow_pkg ~/.config/yazi            yazi
    stow_pkg ~/.zshrc                  zsh         true

    echo ""

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
