#!/usr/bin/env bash
#
# install.sh — unattended Arch Linux installer for HamzaHeikal2011/dotfiles
#
# Run from a live Arch ISO as root:
#   curl -fsSL https://raw.githubusercontent.com/HamzaHeikal2011/dotfiles/master/install.sh | bash
#   (or: bash install.sh, if you've already got it on disk)
#
# What this does, top to bottom:
#   1. Sanity checks (root, live ISO, UEFI, network)
#   2. Bootstraps `gum` for the TUI wizard
#   3. Interactive setup screen: hostname, username, password, sudo,
#      timezone, keyboard layout, locale/language, target disk
#   4. Partitions + formats the chosen disk (GPT: ESP + Btrfs w/ subvolumes)
#   5. pacstrap's the curated package set (base + your full desktop stack)
#   6. Chroots in to finish: locale/timezone/hostname, user + sudo, zsh as
#      default shell, docker install + group, Limine bootloader, yay +
#      AUR packages, dotfiles clone + stow
#
# NOTE ON SCOPE: this provisions the *system*. It does not restore your
# custom ~/.local/bin tools (hermes, hyprmcp, ct2-* converters, etc.) or
# Homebrew-only formulae with no AUR equivalent (googleworkspace-cli,
# llmfit, ghui, sigye) — those need their own follow-up step; see the
# MANUAL_FOLLOWUP block near the bottom for the full list.
#
# NOTE ON HARDWARE: assumes UEFI boot and Intel graphics/microcode (matches
# your current explicit package list: intel-ucode, vulkan-intel). If you're
# running this on different hardware, edit MICROCODE_PKG and the GPU driver
# section before running.

set -euo pipefail

# ────────────────────────────────────────────────────────────────────────
# 0. Preflight
# ────────────────────────────────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
  echo "This must be run as root (it's meant to run from the live ISO)." >&2
  exit 1
fi

if [[ ! -d /run/archiso ]]; then
  echo "Warning: /run/archiso not found — this doesn't look like the live ISO." >&2
  read -rp "Continue anyway? [y/N] " confirm
  [[ $confirm =~ ^[Yy]$ ]] || exit 1
fi

if [[ ! -d /sys/firmware/efi ]]; then
  echo "This system isn't booted in UEFI mode. This script only handles UEFI. Aborting." >&2
  exit 1
fi

if ! ping -c1 -W3 archlinux.org &>/dev/null; then
  echo "No network connectivity detected. Connect (iwctl / nmtui / ethernet) and re-run." >&2
  exit 1
fi

echo "Syncing package databases..."
pacman -Sy --noconfirm >/dev/null

echo "Bootstrapping gum for the setup wizard..."
pacman -S --needed --noconfirm gum >/dev/null

# ────────────────────────────────────────────────────────────────────────
# 1. TUI wizard
# ────────────────────────────────────────────────────────────────────────

GUM_STYLE=(gum style --border double --border-foreground 82 --padding "1 2" --margin "1 0")

banner() {
  "${GUM_STYLE[@]}" "$1"
}

wizard() {
  clear
  gum style --foreground 82 --bold --align center --width 60 <<'EOF'
 _   _                          ____       _
| | | | __ _ _ __ ___  ______ _/ ___|  ___| |_ _   _ _ __
| |_| |/ _` | '_ ` _ \|_  / _` \___ \ / _ \ __| | | | '_ \
|  _  | (_| | | | | | |/ / (_| |___) |  __/ |_| |_| | |_) |
|_| |_|\__,_|_| |_| |_/___\__,_|____/ \___|\__|\__,_| .__/
                                                     |_|
EOF
  echo

  HOSTNAME=$(gum input --placeholder "hostname" --value "main-500")
  USERNAME=$(gum input --placeholder "username")

  while true; do
    PASSWORD=$(gum input --password --placeholder "password")
    PASSWORD_CONFIRM=$(gum input --password --placeholder "confirm password")
    [[ "$PASSWORD" == "$PASSWORD_CONFIRM" && -n "$PASSWORD" ]] && break
    gum style --foreground 196 "Passwords didn't match (or were empty) — try again."
  done

  if gum confirm "Grant $USERNAME sudo access?"; then
    SUDO_MAIN="yes"
  else
    SUDO_MAIN="no"
  fi

  EXTRA_SUDO_USERS=""
  if gum confirm "Add any additional sudo users?"; then
    EXTRA_SUDO_USERS=$(gum input --placeholder "comma-separated usernames, e.g. alice,bob")
  fi

  echo "Loading timezone list..."
  TIMEZONE=$(find /usr/share/zoneinfo -type f -printf '%P\n' | sort | gum filter --placeholder "timezone (e.g. Europe/Copenhagen)" --height 15)

  echo "Loading keyboard layouts..."
  KEYMAP=$(localectl list-keymaps | gum filter --placeholder "keyboard layout (console, e.g. us)" --height 15)

  echo "Loading locales..."
  LOCALE=$(grep -E '^#?[a-zA-Z]+_[A-Z]+\.(UTF-8|utf8)' /etc/locale.gen | sed 's/^#//' | awk '{print $1}' | sort -u | gum filter --placeholder "locale (e.g. en_US.UTF-8)" --height 15)

  echo "Scanning disks..."
  mapfile -t DISK_LINES < <(lsblk -dpno NAME,SIZE,MODEL -e7,11 | grep -v loop)
  DISK_CHOICE=$(printf '%s\n' "${DISK_LINES[@]}" | gum choose --header "Target disk (THIS WILL BE ERASED)")
  DISK=$(awk '{print $1}' <<<"$DISK_CHOICE")

  # ── review screen ──
  clear
  banner "Does this look right?"
  gum table --print <<EOF
Field,Value
Hostname,$HOSTNAME
Username,$USERNAME
Sudo (main user),$SUDO_MAIN
Extra sudo users,${EXTRA_SUDO_USERS:-none}
Timezone,$TIMEZONE
Keyboard,$KEYMAP
Locale,$LOCALE
Target disk,$DISK_CHOICE
EOF
  echo
  if ! gum confirm "Proceed with these settings?"; then
    echo "Restarting wizard..."
    wizard
    return
  fi

  echo
  gum style --foreground 196 --bold "FINAL WARNING: $DISK will be completely wiped."
  TYPED=$(gum input --placeholder "Type ERASE to confirm")
  if [[ "$TYPED" != "ERASE" ]]; then
    echo "Confirmation not received. Aborting."
    exit 1
  fi
}

wizard

# ────────────────────────────────────────────────────────────────────────
# 2. Partitioning (GPT: ESP + Btrfs)
# ────────────────────────────────────────────────────────────────────────

echo "Partitioning $DISK..."

# Handle nvme-style partition naming (nvme0n1 -> nvme0n1p1) vs sdX -> sdX1
if [[ "$DISK" == *nvme* || "$DISK" == *mmcblk* ]]; then
  PART_SUFFIX="p"
else
  PART_SUFFIX=""
fi
ESP="${DISK}${PART_SUFFIX}1"
ROOT_PART="${DISK}${PART_SUFFIX}2"

wipefs -af "$DISK"
parted -s "$DISK" \
  mklabel gpt \
  mkpart ESP fat32 1MiB 1025MiB \
  set 1 esp on \
  mkpart primary btrfs 1025MiB 100%

partprobe "$DISK"
sleep 2

mkfs.fat -F32 -n ESP "$ESP"
mkfs.btrfs -f -L ROOT "$ROOT_PART"

echo "Creating Btrfs subvolumes..."
mount "$ROOT_PART" /mnt
for sv in @ @home @snapshots @var_log @cache; do
  btrfs subvolume create "/mnt/$sv"
done
umount /mnt

BTRFS_OPTS="rw,noatime,compress=zstd,ssd,discard=async"
mount -o "$BTRFS_OPTS,subvol=@" "$ROOT_PART" /mnt
mkdir -p /mnt/{home,.snapshots,var/log,var/cache,boot}
mount -o "$BTRFS_OPTS,subvol=@home" "$ROOT_PART" /mnt/home
mount -o "$BTRFS_OPTS,subvol=@snapshots" "$ROOT_PART" /mnt/.snapshots
mount -o "$BTRFS_OPTS,subvol=@var_log" "$ROOT_PART" /mnt/var/log
mount -o "$BTRFS_OPTS,subvol=@cache" "$ROOT_PART" /mnt/var/cache
mount "$ESP" /mnt/boot

# ────────────────────────────────────────────────────────────────────────
# 3. Package set
# ────────────────────────────────────────────────────────────────────────

BASE_PKGS=(
  base base-devel linux linux-firmware
  intel-ucode  # swap for amd-ucode if not on Intel
  btrfs-progs efibootmgr limine
  networkmanager network-manager-applet iwd dnsmasq
  sudo git stow zsh
)

NATIVE_PKGS=(
  7zip acpi alsa-utils apparmor audacity aurpublish baobab bat blender
  bluetui bluez bluez-utils brightnessctl btop chafa cronie cups
  cups-pk-helper dust ex-vi-compat eza fastfetch fd flatpak
  ghostty github-cli gnome-backgrounds gnome-calculator gnome-calendar
  gnome-characters gnome-clocks gnome-color-manager gnome-connections
  gnome-contacts gnome-disk-utility gnome-font-viewer gnome-keyring
  gnome-logs gnome-maps gnome-menus gnome-remote-desktop
  gnome-settings-daemon gnome-software gnome-system-monitor
  gnome-text-editor gnome-tour gnome-tweaks gnome-user-share
  gnome-weather greetd greetd-tuigreet grim gst-plugin-pipewire
  gst-thumbnailers gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2
  gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd htop hypridle
  hyprland hyprlock hyprpicker hyprshutdown hyprsunset impala
  inetutils jq kdenlive keyd kvantum lazydocker lazygit less libpulse
  libva-intel-driver libvirt loupe luarocks lvm2 man-db
  multipath-tools nano neovim nmap noto-fonts noto-fonts-cjk
  noto-fonts-emoji npm obs-studio obsidian orca pipewire pipewire-alsa
  pipewire-jack pipewire-pulse polkit-kde-agent power-profiles-daemon
  powertop proton-vpn-cli proton-vpn-gtk-app python-onnxscript
  python-pip python-pytorch python-torchvision python-typer
  qemu-desktop qt5ct qt5-wayland qt6ct qt6-wayland radicale ripgrep
  rofi rygel satty sdl3 simple-scan slurp smartmontools socat starship
  steam strace sushi swaybg swayosd system-config-printer tailscale
  tecla timeshift tmux torbrowser-launcher tuned udiskie ufw uwsm vim
  virt-manager virt-viewer vlc vlc-plugin-ffmpeg vulkan-intel
  vulkan-nouveau vulkan-radeon weechat wget wiremix wireplumber
  wl-clipboard wofi xdg-desktop-portal-hyprland xdg-user-dirs-gtk
  xdg-utils xf86-video-amdgpu xf86-video-ati xf86-video-nouveau
  xfce4-power-manager xfce4-settings xmlstarlet yazi zoxide
  zram-generator
  docker docker-compose
)
# Removed vs. your inventory: waybar (dead, Quickshell replaced it), maim
# (dead, screenshots use grim+slurp per bin/capture-screenshot), xclip/xsel
# (X11-only, dead under Wayland), flatpak-builder (dropping Flatpak apps
# other than the OBS migration, which is now native obs-studio above).
# Added: jq, satty, wl-clipboard (real deps of bin/capture-screenshot),
# sdl3 (now in extra/, replaces the brew formula), obs-studio (native).

AUR_PKGS=(
  adwaita-qt5 adwaita-qt6 dmg2img dragon-drop fetch-git hyprmon-bin
  localsend-bin python-blake3 python-devtools python-diskcache
  python-gguf python-materialyoucolor python-partial-json-parser
  python-pkg_resources python-prometheus-fastapi-instrumentator
  python-pybase64 python-sentencepiece python-tokenizers
  python-transformers quickshell-git rofi-greenclip sentencepiece
  spotify voxtype-bin xdg-terminal-exec zen-browser-bin
  llama.cpp whisper.cpp
  # elephant: unconfirmed whether still in active use with your rofi setup
  # (only rofi confirmed, not the quickshell-launcher direction yet) —
  # left out for now. Add it back with `yay -S elephant` once you've
  # actually migrated the launcher to Quickshell.
)
# Removed vs. your inventory: everything ending in -debug (auto-generated
# debug-symbol subpackages from yay/makepkg — they come along for free
# when their parent package is built with debug info, no need to list
# them), backlight-git/light (dead, you use brightnessctl), kanata-bin
# (dead, keyd is your remapper), i3lock-color (dead, hyprlock is your
# locker), caelestia-shell (confirmed leftover/reference, not used).
# yay itself isn't in this list — it's bootstrapped separately below.
# Added: llama.cpp, whisper.cpp (were Homebrew formulae; both build fine
# from AUR/extra now — swap for the -vulkan variants if you want GPU accel).

MANUAL_FOLLOWUP=(
  "googleworkspace-cli — no AUR equivalent found, install manually"
  "llmfit — no AUR equivalent found, install manually"
  "ghui — no AUR equivalent found, install manually"
  "sigye — no AUR equivalent found, install manually"
  "npm globals: omniroute, uipro-cli — likely private packages, npm install -g manually with auth"
  "~/.local/bin custom tools: hermes, hermes-acp, hyprmcp, mcp, ct2-* converters, compactllm, etc. — not package-manager tracked, need their own restore step"
)

echo "Installing base system (pacstrap)..."
pacstrap -K /mnt "${BASE_PKGS[@]}" "${NATIVE_PKGS[@]}"

genfstab -U /mnt >> /mnt/etc/fstab

# ────────────────────────────────────────────────────────────────────────
# 4. Stage 2: write config for chroot, then chroot in
# ────────────────────────────────────────────────────────────────────────

cat > /mnt/root/chroot-vars.sh <<EOF
HOSTNAME="$HOSTNAME"
USERNAME="$USERNAME"
PASSWORD="$PASSWORD"
SUDO_MAIN="$SUDO_MAIN"
EXTRA_SUDO_USERS="$EXTRA_SUDO_USERS"
TIMEZONE="$TIMEZONE"
KEYMAP="$KEYMAP"
LOCALE="$LOCALE"
ROOT_PART="$ROOT_PART"
EOF
chmod 600 /mnt/root/chroot-vars.sh

# AUR package list is passed in as its own file to avoid quoting hell
printf '%s\n' "${AUR_PKGS[@]}" > /mnt/root/aur-pkgs.txt

cat > /mnt/root/chroot-setup.sh <<'CHROOT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source /root/chroot-vars.sh

# --- Timezone ---
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

# --- Locale ---
sed -i "s/^#\?\($LOCALE\)/\1/" /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# --- Keyboard (console + persist for X/Wayland via keyd anyway) ---
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# --- Hostname ---
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

# --- Root account: locked, use sudo instead ---
passwd -l root

# --- Main user, zsh as default shell ---
useradd -m -G wheel -s /usr/bin/zsh "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

if [[ "$SUDO_MAIN" == "yes" ]]; then
  echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/10-wheel
  chmod 440 /etc/sudoers.d/10-wheel
fi

if [[ -n "$EXTRA_SUDO_USERS" ]]; then
  IFS=',' read -ra EXTRAS <<< "$EXTRA_SUDO_USERS"
  for u in "${EXTRAS[@]}"; do
    u_trimmed=$(echo "$u" | xargs)
    [[ -z "$u_trimmed" ]] && continue
    id "$u_trimmed" &>/dev/null || useradd -m -G wheel -s /usr/bin/zsh "$u_trimmed"
    usermod -aG wheel "$u_trimmed"
  done
fi

# --- zram (no swap partition, matches your existing setup) ---
cat > /etc/systemd/zram-generator.conf <<ZRAM
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
ZRAM

# --- mkinitcpio: enable btrfs + keyd-friendly HOOKS ---
sed -i 's/^MODULES=.*/MODULES=(btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

# --- Bootloader: Limine (UEFI) ---
mkdir -p /boot/EFI/limine /boot/EFI/BOOT
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/BOOTX64.EFI
cp /usr/share/limine/limine-uefi-cd.bin /boot/EFI/limine/ 2>/dev/null || true

ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
cat > /boot/limine.conf <<LIMINE
timeout: 3

/Arch Linux
    protocol: linux
    kernel_path: boot():/vmlinuz-linux
    kernel_cmdline: root=UUID=${ROOT_UUID} rootflags=subvol=@ rw
    module_path: boot():/initramfs-linux.img

/Arch Linux (fallback)
    protocol: linux
    kernel_path: boot():/vmlinuz-linux
    kernel_cmdline: root=UUID=${ROOT_UUID} rootflags=subvol=@ rw
    module_path: boot():/initramfs-linux-fallback.img
LIMINE

efibootmgr --create --disk "${ROOT_PART%[0-9]*}" --part 1 \
  --loader '\EFI\BOOT\BOOTX64.EFI' --label "Limine" --unicode || true

# --- Services ---
systemctl enable NetworkManager
systemctl enable docker
systemctl enable keyd
systemctl enable greetd
systemctl enable bluetooth
systemctl enable cronie
systemctl enable tailscaled 2>/dev/null || true
systemctl enable ufw

# --- Docker group ---
usermod -aG docker "$USERNAME"

# --- yay bootstrap (build as the main user, not root) ---
sudo -u "$USERNAME" bash -c '
  cd /tmp
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
'

# --- AUR packages ---
# (neither pacman nor yay reads a package list from stdin via "-S -", so
# read the file into an array and pass it as normal arguments)
mapfile -t AUR_PKG_LIST < /root/aur-pkgs.txt
sudo -u "$USERNAME" yay -S --noconfirm --needed "${AUR_PKG_LIST[@]}"

# --- Dotfiles: clone + stow (repo isn't assumed to exist on this box) ---
DOTFILES_PATH="/home/$USERNAME/.dotfiles"
sudo -u "$USERNAME" git clone https://github.com/HamzaHeikal2011/dotfiles.git "$DOTFILES_PATH"
sudo -u "$USERNAME" bash -c "cd '$DOTFILES_PATH' && bin/init" || \
  echo "bin/init did not complete cleanly — stow manually after first boot."

echo "Chroot-stage setup complete."
CHROOT_EOF

chmod +x /mnt/root/chroot-setup.sh
arch-chroot /mnt /root/chroot-setup.sh

# ────────────────────────────────────────────────────────────────────────
# 5. Cleanup
# ────────────────────────────────────────────────────────────────────────

shred -u /mnt/root/chroot-vars.sh 2>/dev/null || rm -f /mnt/root/chroot-vars.sh
rm -f /mnt/root/chroot-setup.sh /mnt/root/aur-pkgs.txt

echo
gum style --foreground 82 --bold "Install complete."
echo "Manual follow-up items (no package-manager path found):"
printf '  - %s\n' "${MANUAL_FOLLOWUP[@]}"
echo
if gum confirm "Unmount and reboot now?"; then
  umount -R /mnt
  reboot
fi
