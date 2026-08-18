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

`install.sh` symlinks each item into place. Anything already at the target
path (real file/dir) is moved into `~/.dotfiles-backup/<timestamp>/` first,
so it's non-destructive and safe to re-run.

Because it's symlinks, editing configs on the live machine and running
`git add / commit / push` from `~/dotfiles` is enough to update the backup.

## Notes

- `config/hypr/config/monitors.lua` hardcodes this machine's monitor
  outputs/modes — check it against `hyprctl monitors` on the new machine.
- `config/kitty/themes/noctalia.conf` is intentionally not tracked; Noctalia
  regenerates it at runtime to theme Kitty to match the current wallpaper.
