#!/usr/bin/env python3
"""Cycle the bar layout by selecting the same index on every keyboard."""
import fcntl
import json
import os
from pathlib import Path
import subprocess
import sys

mode = sys.argv[1] if len(sys.argv) > 1 else "next"
if mode not in ("next", "sync", "0", "1"):
    raise SystemExit("usage: keyboard-layout.py [next|sync|0|1]")
runtime = Path(os.environ["XDG_RUNTIME_DIR"])
with (runtime / "hypr-keyboard-layout.lock").open("w") as lock:
    fcntl.flock(lock, fcntl.LOCK_EX)
    devices = json.loads(subprocess.check_output(["hyprctl", "devices", "-j"]))
    keyboards = [k for k in devices["keyboards"]
                 if not k["name"].startswith("hl-virtual-keyboard-")]
    if not keyboards:
        raise SystemExit("No physical keyboard found")
    main = next((k for k in keyboards if k.get("main")), keyboards[0])
    index = main["active_layout_index"]
    if mode == "next":
        index = (index + 1) % len(main["layout"].split(","))
    elif mode in ("0", "1"):
        index = int(mode)
    # Noctalia's virtual keyboard has its own single-layout keymap. Skip it.
    commands = [f"switchxkblayout {k['name']} {index}" for k in keyboards
                if k["active_layout_index"] != index]
    if commands:
        response = subprocess.check_output(["hyprctl", "--batch", ";".join(commands)], text=True)
        if any(line.strip() != "ok" for line in response.splitlines() if line.strip()):
            raise SystemExit(response)
    print("Portuguese (Brazil)" if index == 0 else "English (US, International)")
