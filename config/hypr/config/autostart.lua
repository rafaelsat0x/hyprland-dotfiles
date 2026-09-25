-- Auto-start config

-- Apply the initial workspace placement only after an output is ready. Shelling
-- out to hyprctl from hyprland.start can run before a late output appears,
-- which is the race this is intended to prevent.
local function place_default_workspace(monitor)
    local workspace

    if monitor.name == MONITOR1 then
        workspace = "1"
    elseif MONITOR2 ~= "" and monitor.name == MONITOR2 then
        workspace = "11"
    else
        return
    end

    hl.dispatch(hl.dsp.workspace.move({ workspace = workspace, monitor = monitor }))
end

hl.on("monitor.added", place_default_workspace)

hl.on("hyprland.start", function()
    -- monitor.added normally handles this; the loop also covers outputs which
    -- were ready before the event callback was registered.
    for _, monitor in ipairs(hl.get_monitors()) do
        place_default_workspace(monitor)
    end
    hl.dispatch(hl.dsp.focus({ workspace = "1" }))

    -- UWSM already exports the Wayland session environment. Launch long-lived
    -- applications through it so they do not remain in Hyprland's cgroup.
    hl.exec_cmd("uwsm app -- noctalia")

    -- config/lid.lua owns lid behavior. Prevent logind's default suspend action
    -- from racing with those switch binds while this session is alive.
    hl.exec_cmd("systemd-inhibit --what=handle-lid-switch --who=Hyprland --why='Hyprland handles lid events' --mode=block sleep infinity")

    hl.exec_cmd("xhost +SI:localuser:root")
end)
