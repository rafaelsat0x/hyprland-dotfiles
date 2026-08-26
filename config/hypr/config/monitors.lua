-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

-- Kept as a named global so config/lid.lua can re-apply the exact same spec
-- when the laptop panel is brought back up, instead of duplicating the mode.
LAPTOP_PANEL = {
    output    = MONITOR1,
    mode      = "1920x1080@120",
    position  = "0x0",
    scale     = 1,
}

hl.monitor(LAPTOP_PANEL)

hl.monitor({
    output    = MONITOR2,
    mode      = "1920x1080@240",
    scale     = 1,
    position  = "1920x0",
})

-- Scale reference for this 1920x1080 panel. Only these divide cleanly into
-- whole logical pixels; anything else will be rejected or look blurry:
--   1     -> 1920x1080  (native, sharpest)
--   1.2   -> 1600x900
--   1.25  -> 1536x864   (good if UI feels small)
--   1.5   -> 1280x720   (large)
