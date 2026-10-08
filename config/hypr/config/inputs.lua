-- Input configuration

-- The bar selects the shared default for unpinned keyboards. A single layout
-- also makes newly connected keyboards inherit that selection immediately.
-- Managed by scripts/keyboard-layout.py. Keep the default inline so automatic
-- reloads never depend on a separate generated module being available.
local keyboard_default = { layout = "br", variant = "abnt2" }
hl.config({
    input = {
        kb_layout  = keyboard_default.layout,
        kb_variant = keyboard_default.variant,
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

-- Laptop built-in keyboard: always Brazilian Portuguese (ABNT2).
-- Both internal keyboard interfaces are pinned.
hl.device({
    name       = "ite-tech.-inc.-ite-device(8910)-keyboard",
    kb_layout  = "br",
    kb_variant = "abnt2",
    kb_options = "",
})
hl.device({
    name       = "at-translated-set-2-keyboard",
    kb_layout  = "br",
    kb_variant = "abnt2",
    kb_options = "",
})


-- Razer Huntsman: always US, preserving the existing International variant.
-- Its four keyboard interfaces and mouse interface share the same device name;
-- Hyprland adds numeric suffixes to distinguish them.
for index = 0, 4 do
    local suffix = index == 0 and "" or "-" .. index
    hl.device({
        name       = "razer-razer-huntsman-v2-tenkeyless" .. suffix,
        kb_layout  = "us",
        kb_variant = "intl",
        kb_options = "",
    })
end

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
