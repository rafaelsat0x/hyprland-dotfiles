#!/usr/bin/env bash
#
# Installs this dotfiles repo by symlinking each config into place.
# Safe to re-run: existing real files/dirs are backed up once, existing
# correct symlinks are left alone.
#
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
backed_up=0

# source (in this repo) -> target (in $HOME)
LINKS=(
    "config/hypr:.config/hypr"
    "config/noctalia:.config/noctalia"
    "config/uwsm:.config/uwsm"
    "config/kitty:.config/kitty"
    "home/.zshrc:.zshrc"
    "home/.p10k.zsh:.p10k.zsh"
)

link_one() {
    local src="$REPO_DIR/$1"
    local dst="$HOME/$2"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "ok      $2 (already linked)"
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$2")"
        mv "$dst" "$BACKUP_DIR/$2"
        backed_up=1
        echo "backup  $2 -> ${BACKUP_DIR#"$HOME"/}/$2"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked  $2 -> ${src#"$REPO_DIR"/}"
}

echo "Installing dotfiles from $REPO_DIR"
echo

for entry in "${LINKS[@]}"; do
    link_one "${entry%%:*}" "${entry##*:}"
done

echo
if [ "$backed_up" -eq 1 ]; then
    echo "Existing configs were backed up to: $BACKUP_DIR"
fi
echo "Done. Log out/reboot (or restart Hyprland) for everything to take effect."
echo "Reminder: config/hypr/config/monitors.lua has this machine's monitor layout - check it matches the new machine's outputs (hyprctl monitors)."
