#!/usr/bin/env bash
#
# Installs this dotfiles repo by copying each config into place (real files,
# not symlinks). Safe to re-run: a target is only touched if it differs from
# the repo's copy, and anything it overwrites is backed up first.
#
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
backed_up=0

# source (in this repo) -> target (in $HOME)
ITEMS=(
    "config/hypr:.config/hypr"
    "config/noctalia:.config/noctalia"
    "config/uwsm:.config/uwsm"
    "config/kitty:.config/kitty"
    "home/.zshrc:.zshrc"
    "home/.p10k.zsh:.p10k.zsh"
)

install_one() {
    local src="$REPO_DIR/$1"
    local dst="$HOME/$2"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if diff -rq "$src" "$dst" >/dev/null 2>&1; then
            echo "ok      $2 (up to date)"
            return
        fi
        mkdir -p "$BACKUP_DIR/$(dirname "$2")"
        mv "$dst" "$BACKUP_DIR/$2"
        backed_up=1
        echo "backup  $2 -> ${BACKUP_DIR#"$HOME"/}/$2"
    fi

    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
    echo "copied  $2 <- ${src#"$REPO_DIR"/}"
}

echo "Installing dotfiles from $REPO_DIR"
echo

for entry in "${ITEMS[@]}"; do
    install_one "${entry%%:*}" "${entry##*:}"
done

echo
if [ "$backed_up" -eq 1 ]; then
    echo "Existing configs were backed up to: $BACKUP_DIR"
fi
echo "Done. Log out/reboot (or restart Hyprland) for everything to take effect."
echo "Reminder: config/hypr/config/monitors.lua has this machine's monitor layout - check it matches the new machine's outputs (hyprctl monitors)."
echo "Note: these are plain copies, not symlinks - after editing a live config, re-copy it into ~/dotfiles before committing (this script is one-way: repo -> \$HOME)."
