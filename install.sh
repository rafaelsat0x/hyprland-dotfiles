#!/usr/bin/env bash
#
# Installs this dotfiles repo by copying each tracked config file into place
# (real files, not symlinks). Safe to re-run: a target is only touched if it
# differs from the repo's copy, and anything it overwrites is backed up first.
# Files that exist only in the destination (for example, generated Noctalia
# theme files) are left alone.
#
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
backed_up=0

# directory source (in this repo) -> directory target (in $HOME)
TREES=(
    "config/hypr:.config/hypr"
    "config/noctalia:.config/noctalia"
    "config/uwsm:.config/uwsm"
    "config/kitty:.config/kitty"
)

# file source (in this repo) -> file target (in $HOME)
FILES=(
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

for entry in "${TREES[@]}"; do
    src_root="${entry%%:*}"
    dst_root="${entry##*:}"

    while IFS= read -r -d '' src; do
        relative_path="${src#"$REPO_DIR/$src_root/"}"
        install_one "$src_root/$relative_path" "$dst_root/$relative_path"
    done < <(find "$REPO_DIR/$src_root" \( -type f -o -type l \) -print0 | sort -z)
done

for entry in "${FILES[@]}"; do
    install_one "${entry%%:*}" "${entry##*:}"
done

echo
if [ "$backed_up" -eq 1 ]; then
    echo "Existing configs were backed up to: $BACKUP_DIR"
fi
echo "Done. Log out/reboot (or restart Hyprland) for everything to take effect."
echo "Reminder: config/hypr/config/monitors.lua has this machine's monitor layout - check it matches the new machine's outputs (hyprctl monitors)."
echo "Note: these are plain copies, not symlinks - after editing a live config, re-copy it into ~/dotfiles before committing (this script is one-way: repo -> \$HOME)."
