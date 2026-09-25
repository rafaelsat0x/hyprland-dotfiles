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

Requires: Hyprland, Noctalia, UWSM, Kitty, Zsh, Oh My Zsh, and Powerlevel10k
already installed (this repo only covers config, not package installation).

```sh
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` copies each tracked item into place as a real file (not a
symlink). A target is only touched if it differs from the repo's copy;
anything it overwrites is moved into `~/.dotfiles-backup/<timestamp>/` first,
so it's non-destructive and safe to re-run. Destination-only files are
preserved, including the runtime-generated Noctalia theme files.

Because these are plain copies, the flow is one-way (repo -> `$HOME`): after
editing a live config, copy it back into `~/dotfiles` and
`git add / commit / push` to update the backup — `install.sh` won't pick up
live edits on its own.

## Notes

- `config/hypr/config/monitors.lua` hardcodes this machine's monitor
  outputs/modes — check it against `hyprctl monitors` on the new machine.
- `config/kitty/themes/noctalia.conf` is intentionally not tracked; Noctalia
  regenerates it at runtime to theme Kitty to match the current wallpaper.
- `config/hypr/noctalia.lua` is likewise not tracked; Noctalia renders it from
  its built-in Hyprland template on every theme change, and `hyprland.lua`
  requires it to apply live border/group colors. Requires the `hyprland`
  builtin template to be enabled (see `config/noctalia/config.toml`'s
  `theme.templates.builtin_ids`, and — on the machine itself, not this repo —
  the same list in `~/.local/state/noctalia/settings.toml`).
