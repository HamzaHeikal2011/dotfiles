-- Generated from consolidated looknfeel.conf
local activeBorderColor = "#8A8A8A"
local inactiveBorderColor = "#2A2A2A"

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		["col.active_border"] = activeBorderColor,
		["col.inactive_border"] = inactiveBorderColor,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 0,
		shadow = {
			enabled = true,
			range = 2,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},
	group = {
		["col.border_active"] = activeBorderColor,
		["col.border_inactive"] = inactiveBorderColor,
		groupbar = {
			font_size = 12,
			font_family = "monospace",
			font_weight_active = "ultraheavy",
			font_weight_inactive = "normal",
			indicator_height = 0,
			indicator_gap = 5,
			height = 22,
			gaps_in = 5,
			gaps_out = 0,
			text_color = "rgb(ffffff)",
			text_color_inactive = "rgba(ffffff90)",
			["col.active"] = "rgba(00000040)",
			["col.inactive"] = "rgba(00000020)",
			gradients = true,
			gradient_rounding = 0,
			gradient_round_only_edges = false,
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
	master = {
		new_status = "master",
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		focus_on_activate = true,
		anr_missed_pings = 3,
		on_focus_under_fullscreen = 1,
	},
	cursor = {
		hide_on_key_press = true,
		warp_on_change_workspace = 1,
	},
	binds = {
		hide_special_on_workspace_change = true,
	},
})

-- Final Overrides
hl.config({
	general = {
		["col.active_border"] = activeBorderColor,
		border_size = 1,
	},
	group = {
		["col.border_active"] = activeBorderColor,
	},
	animations = {
		enabled = true,
	},
	decoration = {
		rounding = 8,
		blur = {
			enabled = true,
			special = false,
			size = 5,
			passes = 3,
			new_optimizations = true,
			xray = false,
		},
		active_opacity = 0.95,
		inactive_opacity = 0.85,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.curve("apple", { type = "spring", mass = 1, stiffness = 80, dampening = 22 })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 50, dampening = 10 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 10, spring = "apple" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, spring = "apple", style = "slidevert" })
