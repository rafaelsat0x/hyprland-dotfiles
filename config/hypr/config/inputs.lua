-- Input configuration

-- Global defaults. Every keyboard gets both layouts and can toggle between them
-- with Alt + Shift. Order matters: the first layout listed is the active one.
hl.config({
    input = {
        kb_layout  = "us,br",
        kb_variant = "intl,abnt2",
        kb_options = "grp:alt_shift_toggle",
        -- sensitivity = -0.25,
        accel_profile = "flat",

        -- Natural scrolling for the touchpad (content follows your fingers)
        touchpad = {
            natural_scroll = true,
        },

        -- Uncomment to also invert the wheel on mice. Separate setting:
        -- the touchpad block above does not affect external mice.
        -- natural_scroll = true,
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

-- Per-device overrides. Same two layouts, different starting one, so each
-- keyboard boots into its own native layout and still toggles independently.

-- Laptop built-in keyboard: starts on ABNT2.
-- This machine exposes two candidates for the internal board; the ITE one is
-- flagged "main: yes" in hyprctl devices, but at-translated-set-2 is kept as a
-- fallback because either can be the one actually delivering keystrokes.
-- Once you confirm which is live, you can delete the other block.
hl.device({
    name       = "ite-tech.-inc.-ite-device(8910)-keyboard",
    kb_layout  = "br,us",
    kb_variant = "abnt2,intl",
    kb_options = "grp:alt_shift_toggle",
})
hl.device({
    name       = "at-translated-set-2-keyboard",
    kb_layout  = "br,us",
    kb_variant = "abnt2,intl",
    kb_options = "grp:alt_shift_toggle",
})


--Touchpad - turning on adaptive mode
hl.device({
    name       = "msft0001:01-06cb:7f28-touchpad",
    accel_profile = "adaptive"
})

-- Alternative to the Alt + Shift XKB toggle: uncomment for a Hyprland bind
-- instead. "current" targets the keyboard you last typed on.
-- hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
