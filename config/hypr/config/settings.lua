local constants = require("config.constants")

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.config({
	env = {
		"HYPRCURSOR_THEME,catppuccin-mocha-dark-cursors",
		"HYPRCURSOR_SIZE,24",
		"XCURSOR_THEME,catppuccin-mocha-dark-cursors",
		"XCURSOR_SIZE,24",
	},
	general = {
		border_size = 1,
		gaps_in = constants.gaps_in,
		gaps_out = { 0, 0, 9, 50 },
		layout = constants.default_layout,
		resize_on_border = true,
	},
	decoration = {
		rounding = 10,
		active_opacity = 0.95,
		inactive_opacity = 0.90,
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = true,
			special = true,
			size = 3,
			passes = 2,
			new_optimizations = true,
		},
	},
	input = {
		repeat_rate = 50,
		repeat_delay = 300,
		sensitivity = 6,
		accel_profile = "flat",
		natural_scroll = false,
		touchpad = {
			natural_scroll = true,
		},
	},
	gestures = {
		workspace_swipe_distance = 300,
	},
	misc = {
		disable_hyprland_logo = true,
		font_family = constants.font,
	},
	xwayland = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
		special_scale_factor = 0.9,
	},
})
