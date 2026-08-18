# dotfiles

Consolidated backup of everything that makes up my current Hyprland UI:
Hyprland, Noctalia (shell/bar), UWSM (session manager), Kitty, and my zsh
prompt (zshrc + p10k).

## Layout

```
config/hypr/       -> ~/.config/hypr
config/noctalia/   -> ~/.config/noctalia
config/uwsm/       -> ~/.config/uwsm
config/kitty/      -> ~/.config/kitty
home/.zshrc         -> ~/.zshrc
home/.p10k.zsh       -> ~/.p10k.zsh
```

## Install on a new machine

Requires: hyprland, noctalia, uwsm, kitty, zsh + powerlevel10k already
installed (this repo only covers config, not package installation).

```sh
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` copies each item into place as real files (not symlinks).
A target is only touched if it differs from the repo's copy; anything it
overwrites is moved into `~/.dotfiles-backup/<timestamp>/` first, so it's
non-destructive and safe to re-run.

Because these are plain copies, the flow is one-way (repo -> `$HOME`): after
editing a live config, copy it back into `~/dotfiles` and
`git add / commit / push` to update the backup — `install.sh` won't pick up
live edits on its own.

## Notes

- `config/hypr/config/monitors.lua` hardcodes this machine's monitor
  outputs/modes — check it against `hyprctl monitors` on the new machine.
- `config/kitty/themes/noctalia.conf` is intentionally not tracked; Noctalia
  regenerates it at runtime to theme Kitty to match the current wallpaper.
