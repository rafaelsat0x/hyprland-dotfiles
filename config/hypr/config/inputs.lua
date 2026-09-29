-- Input configuration

-- Both layouts are available through the bar. No keyboard shortcut changes
-- the layout; XKB group toggles would let individual devices drift apart.
hl.config({
    input = {
        -- Keep this order identical to the per-device overrides below. The
        -- bar associates its labels with these layout indices.
        kb_layout  = "br,us",
        kb_variant = "abnt2,intl",
        kb_options = "",
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
    -- breeze_cursors is an XCursor theme, not a Hyprcursor theme. Disabling
    -- Hyprcursor makes Hyprland use XCURSOR_THEME instead of looking for the
    -- manifest.hl file that Breeze does not provide.
    cursor = {
        enable_hyprcursor = false,
    },
})

-- Per-device overrides. Keep the layout order aligned with the global defaults
-- so the bar's index-based labels match the active keymap.

-- Laptop built-in keyboard: starts on ABNT2.
-- This machine exposes two candidates for the internal board; the ITE one is
-- flagged "main: yes" in hyprctl devices, but at-translated-set-2 is kept as a
-- fallback because either can be the one actually delivering keystrokes.
-- Once you confirm which is live, you can delete the other block.
hl.device({
    name       = "ite-tech.-inc.-ite-device(8910)-keyboard",
    kb_layout  = "br,us",
    kb_variant = "abnt2,intl",
    kb_options = "",
})
hl.device({
    name       = "at-translated-set-2-keyboard",
    kb_layout  = "br,us",
    kb_variant = "abnt2,intl",
    kb_options = "",
})


--Touchpad - turning on adaptive mode
hl.device({
    name       = "msft0001:01-06cb:7f28-touchpad",
    accel_profile = "adaptive"
})

-- Layout switching is intentionally available only from the bar.

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
