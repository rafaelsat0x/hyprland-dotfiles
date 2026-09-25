-- Lid switch handling
--
-- Closing the lid disables the laptop panel outright rather than just blanking
-- it (hl.dsp.dpms). Blanking would leave workspaces 1..10 alive on a screen you
-- can't see, so any window sitting there becomes unreachable. Disabling makes
-- Hyprland evacuate those workspaces onto the remaining monitor, so every open
-- window stays usable on the external display.
--
-- Reopening the lid re-applies the panel spec from config/monitors.lua, and the
-- monitor-bound workspace rules in config/workspaces.lua pull workspaces 1..10
-- back to eDP-1 on their own. Nothing about the workspace layout is rewritten
-- here, so the arrangement you had before the lid closed is what you get back.
--
-- Device name comes from the Switches section of `hyprctl devices`.
local LID_SWITCH = "Lid Switch"

-- Never disable the only screen left. With no external display connected,
-- disabling eDP-1 would leave Hyprland with zero outputs and drop you onto a
-- headless fallback with no way to see it, so in that case the lid does nothing.
local function has_external_display()
    for _, m in ipairs(hl.get_monitors()) do
        if m.name ~= MONITOR1 and not m.is_mirror then
            return true
        end
    end
    return false
end

local function set_laptop_panel(enabled)
    if enabled then
        -- disabled = false has to be set explicitly. Re-applying LAPTOP_PANEL
        -- on its own is a no-op: the spec carries no `disabled` key, so the
        -- disable rule from the lid-close stays in force and the panel never
        -- comes back. Copy the spec rather than mutating the shared global.
        local spec = { disabled = false }
        for k, v in pairs(LAPTOP_PANEL) do
            spec[k] = v
        end
        hl.monitor(spec)
    else
        hl.monitor({ output = MONITOR1, disabled = true })
    end
end

-- switch:on = lid closed, switch:off = lid opened.
-- locked so both still fire while the session is locked.
hl.bind("switch:on:" .. LID_SWITCH, function()
    if has_external_display() then
        set_laptop_panel(false)
    else
        hl.notification.create({
            text = "Lid closed with no external display - keeping " .. MONITOR1 .. " on",
            timeout = 4000,
        })
    end
end, { locked = true })

hl.bind("switch:off:" .. LID_SWITCH, function()
    set_laptop_panel(true)
end, { locked = true })
