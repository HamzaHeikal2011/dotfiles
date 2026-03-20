#!/usr/bin/env bash
# =============================================================================
# Dotfiles Auto Initializer (bash)
# =============================================================================

# --- Colors ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'
info() { echo -e "${CYAN}[INFO]${RESET}  $1"; }
success() { echo -e "${GREEN}[OK]${RESET}    $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET}  $1"; }
error() { echo -e "${RED}[ERR]${RESET}   $1"; }

# --- Stow helper -------------------------------------------------------------
# Usage: stow_pkg <target-to-remove> <stow-package> [is-file]
FAILED=()
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

read -rp "Copy dotfiles automatically? (y/N): " choice

case "$choice" in
y | Y)
  info "Proceeding with dotfiles setup..."
  echo ""

  cd dotfiles || {
    error "Could not find dotfiles directory"
    exit 1
  }

  stow_pkg ~/.bashrc bash true
  stow_pkg ~/.config/fontconfig fontconfig
  stow_pkg ~/.config/ghostty ghostty
  stow_pkg ~/.config/hypr hypr
  stow_pkg ~/.config/nvim nvim
  stow_pkg ~/.config/starship.toml starship true
  stow_pkg ~/.config/swaync swaync
  stow_pkg ~/.config/swayosd swayosd
  stow_pkg ~/.local/share/omarchy/themes/graphite-black theme
  stow_pkg ~/.config/tmux tmux
  stow_pkg ~/.config/walker walker
  stow_pkg ~/.config/waybar waybar
  stow_pkg ~/.config/yazi yazi
  stow_pkg ~/.zshrc zsh true

  echo ""

  # Summary
  if ((${#FAILED[@]} == 0)); then
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

n | N | "")
  echo ""
  success "Aborted. Enjoy :)"
  exit 0
  ;;

*)
  error "Invalid input: '$choice'. Expected y or N."
  exit 1
  ;;
esac
