#!/bin/bash
# Bootstrap a fresh Arch install: paru, packages, then stow dotfiles.
# Usage: ./install.sh [--skip-packages] [--skip-dotfiles]

set -euo pipefail
DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_PATH

info() { printf '\033[1;34m[+]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; }

SKIP_PACKAGES=0
SKIP_DOTFILES=0
for arg in "$@"; do
  case "$arg" in
    --skip-packages) SKIP_PACKAGES=1 ;;
    --skip-dotfiles) SKIP_DOTFILES=1 ;;
    *) err "unknown flag: $arg"; exit 1 ;;
  esac
done

[[ $EUID -eq 0 ]] && { err "run as your normal user, not root (uses sudo where needed)"; exit 1; }
command -v pacman >/dev/null || { err "this is not an Arch system"; exit 1; }

ensure_paru() {
  if command -v paru >/dev/null; then
    info "paru already installed"
    return
  fi
  info "building paru from AUR"
  sudo pacman -S --needed --noconfirm base-devel git
  local tmp
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$tmp"
  (cd "$tmp" && makepkg -si --noconfirm)
  rm -rf "$tmp"
}

_read_list() { grep -vE '^\s*(#|$)' "$1" 2>/dev/null || true; }

install_packages() {
  info "installing base packages"
  mapfile -t base < <(_read_list "$DOTFILES_PATH/install/base.packages")
  if [[ ${#base[@]} -gt 0 ]]; then
    sudo pacman -S --needed --noconfirm "${base[@]}"
  fi

  info "installing AUR packages"
  mapfile -t aur < <(_read_list "$DOTFILES_PATH/install/aur.packages")
  if [[ ${#aur[@]} -gt 0 ]]; then
    paru -S --needed --noconfirm "${aur[@]}"
  fi
}

info "== bootstrap start =="

ensure_paru

if [[ $SKIP_PACKAGES -eq 0 ]]; then
  install_packages
else
  info "skipping package install (--skip-packages)"
fi

if [[ $SKIP_DOTFILES -eq 0 ]]; then
  info "handing off to bin/init to stow dotfiles"
  zsh "$DOTFILES_PATH/bin/init"
else
  info "skipping dotfiles (--skip-dotfiles)"
fi

info "== bootstrap done. Restart your shell (or reboot) to pick up DOTFILES_PATH/PATH changes. =="
