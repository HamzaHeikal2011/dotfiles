#!/usr/bin/env bash
# lib/network-check.sh
#
# Gates install.sh behind a confirmed internet connection before bin/init
# clones the dotfiles repo. Targets the Arch live ISO (iwd + gum are present
# by default). Laptop-first: handles rfkill killswitches and interactive
# WiFi selection, skips the prompt entirely if already online (ethernet,
# pre-existing wifi, etc).

set -euo pipefail

CONNECTIVITY_CHECK_URL="https://archlinux.org"
CONNECTIVITY_TIMEOUT=5

is_online() {
    curl -fsS --max-time "$CONNECTIVITY_TIMEOUT" --head "$CONNECTIVITY_CHECK_URL" >/dev/null 2>&1
}

get_wifi_iface() {
    iwctl device list 2>/dev/null | awk '/station/{print $2; exit}'
}

wifi_menu() {
    local iface
    iface="$(get_wifi_iface)"

    if [[ -z "$iface" ]]; then
        gum style --foreground 1 "No wireless interface found."
        return 1
    fi

    # Laptop killswitches are a common gotcha — clear them before scanning
    rfkill unblock wifi 2>/dev/null || true
    systemctl is-active --quiet iwd || systemctl start iwd

    gum spin --title "Scanning for networks..." -- iwctl station "$iface" scan
    sleep 2

    local networks
    mapfile -t networks < <(
        iwctl station "$iface" get-networks 2>/dev/null \
            | sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g' \
            | sed -n '/^--/,$p' | tail -n +2 \
            | awk 'NF {
                sig=$NF; sec=$(NF-1);
                $NF=""; $(NF-1)="";
                gsub(/ +$/, "");
                print $0 "  [" sec "]"
              }'
    )

    if [[ ${#networks[@]} -eq 0 ]]; then
        gum style --foreground 1 "No networks found."
        return 1
    fi

    local choice ssid
    choice="$(printf '%s\n' "${networks[@]}" | gum choose --header "Select a WiFi network")"
    [[ -z "$choice" ]] && return 1
    ssid="${choice%  \[*}"

    if [[ "$choice" == *"[open]"* ]]; then
        iwctl station "$iface" connect "$ssid"
    else
        local pass
        pass="$(gum input --password --placeholder "Password for $ssid")"
        iwctl --passphrase "$pass" station "$iface" connect "$ssid"
    fi
}

ensure_network() {
    is_online && return 0

    gum style --foreground 3 "No internet connection detected."

    until is_online; do
        gum confirm "Connect to WiFi now?" || {
            gum style --foreground 1 "Network is required to continue."
            exit 1
        }
        wifi_menu || true
        gum spin --title "Verifying connectivity..." -- sleep 3
    done

    gum style --foreground 2 "✓ Network connected."
}

ensure_network
