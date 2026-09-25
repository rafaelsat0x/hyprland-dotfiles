-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Rules are generated from NUM_WPM in variables.lua, so changing that number
-- is all you need to do to add or remove workspaces.
-- Not marked default: window rules in config/windowrules.lua already route
-- game windows here explicitly. Marking it default = true made it compete
-- with workspace 1 for eDP-1's boot-time default, and it was winning
-- because this rule is declared first.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR })

for i = 1, NUM_WPM do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR1, default = (i == 1), persistent = true })
end

-- Give the external display its own equal-sized set of workspaces (11..20
-- for NUM_WPM = 10), since workspace IDs are global and can't be reused
-- across monitors. Use SUPER + <number> to jump to the Nth
-- workspace on whichever monitor is currently focused.
if MONITOR2 ~= "" then
    for i = 1, NUM_WPM do
        hl.workspace_rule({ workspace = tostring(i + 10), monitor = MONITOR2, default = (i == 1), persistent = true })
    end
end
