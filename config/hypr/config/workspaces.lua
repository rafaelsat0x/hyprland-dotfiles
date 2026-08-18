-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Rules are generated from NUM_WPM in variables.lua, so changing that number
-- is all you need to do to add or remove workspaces.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

for i = 1, NUM_WPM do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR1, default = true, persistent = true })
end

-- Give the external display its own equal-sized set of workspaces (11..19
-- for NUM_WPM = 9), since workspace IDs are global and can't be reused
-- across monitors. Use SUPER + CONTROL + <number> to jump to the Nth
-- workspace on whichever monitor is currently focused.
if MONITOR2 ~= "" then
    for i = 1, NUM_WPM do
        hl.workspace_rule({ workspace = tostring(i + 10), monitor = MONITOR2, default = true, persistent = true })
    end
end
