#!/usr/bin/env python3
"""Select the shared layout for other keyboards; preserve device overrides."""
import fcntl
import os
from pathlib import Path
import re
import subprocess
import sys


LAYOUTS = {"br": ("abnt2", "BR"), "us": ("intl", "US")}


def write_atomic(path, text):
    temporary = path.with_name(path.name + ".tmp")
    temporary.write_text(text)
    temporary.replace(path)


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "next"
    if len(sys.argv) > 2 or mode not in ("next", "sync", "0", "1"):
        raise SystemExit("usage: keyboard-layout.py [next|sync|0|1]")

    config = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config")))
    default = config / "hypr/config/inputs.lua"
    label_file = config / "noctalia/keyboard-layout.toml"
    runtime = Path(os.environ["XDG_RUNTIME_DIR"])
    with (runtime / "hypr-keyboard-layout.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        previous = default.read_text()
        pattern = (
            r'local keyboard_default\s*=\s*\{\s*layout\s*=\s*"(br|us)"'
            r'\s*,\s*variant\s*=\s*"[^"]*"\s*\}'
        )
        match = re.search(pattern, previous)
        if not match:
            raise SystemExit(f"Invalid keyboard default in {default}")
        layout = match[1]
        if mode == "next":
            layout = "us" if layout == "br" else "br"
        elif mode in ("0", "1"):
            layout = "br" if mode == "0" else "us"
        variant, label = LAYOUTS[layout]

        # Confirm the compositor is reachable before changing saved settings.
        subprocess.check_output(["hyprctl", "devices", "-j"], text=True)
        content = re.sub(
            pattern,
            f'local keyboard_default = {{ layout = "{layout}", variant = "{variant}" }}',
            previous,
            count=1,
        )
        if content != previous:
            write_atomic(default, content)
        try:
            # Apply the global default while honoring the fixed device layouts.
            # New keyboards inherit this default, including after a restart.
            response = subprocess.check_output(
                ["hyprctl", "reload", "config-only"], text=True
            )
            if response.strip() != "ok":
                raise RuntimeError(response.strip())
            errors = subprocess.check_output(["hyprctl", "configerrors"], text=True)
            if errors.strip():
                raise RuntimeError(errors.strip())
        except (subprocess.CalledProcessError, RuntimeError):
            if content != previous:
                write_atomic(default, previous)
                subprocess.run(["hyprctl", "reload", "config-only"], check=False)
            raise

        # This override avoids rewriting the user's bar configuration.
        label_content = f'[widget.keyboard_layout]\nlabel = "{label}"\n'
        if not label_file.exists() or label_file.read_text() != label_content:
            write_atomic(label_file, label_content)
        print(f"Other keyboards: {label}. Razer: US. Laptop: BR.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, subprocess.CalledProcessError, RuntimeError) as error:
        raise SystemExit(f"Could not apply keyboard layout: {error}")
