-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = GRUVYELLOW,
            inactive_border = GRUVBG0_H,
        },
    },
    group = {
        col = {
            border_active = GRUVBLUE,
            border_inactive = GRUVGRAY,
            border_locked_active = GRUVBG2,
            border_locked_inactive = GRUVGRAY,
        },
        groupbar = {
            col = {
                active = GRUVGREEN,
                inactive = GRUVGRAY,
                locked_active = GRUVBG2,
                locked_inactive = GRUVGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 0,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
