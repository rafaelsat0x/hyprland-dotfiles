-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    -- Force the workspace/monitor bindings after both outputs are actually
    -- live, since eDP-1 can be recognized a beat after other outputs at
    -- boot, causing its default workspace binding to race and land on the
    -- external monitor's workspace block (11) instead of 1. See
    -- config/workspaces.lua for the related workspace-10 note.
    hl.exec_cmd("hyprctl dispatch moveworkspacetomonitor 1 " .. MONITOR1)
    hl.exec_cmd("hyprctl dispatch moveworkspacetomonitor 11 " .. MONITOR2)
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    -- breeze_cursors ships no hyprcursor manifest.hl, so Hyprland's native
    -- cursor manager doesn't reliably auto-load it at startup; force it.
    hl.exec_cmd("hyprctl setcursor breeze_cursors 22")
end)
