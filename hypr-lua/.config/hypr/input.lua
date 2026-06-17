-- Generated from consolidated input.conf
hl.config({
	input = {
		kb_layout = "us,ara",
		kb_options = "grp:alt_shift_toggle",
		touchdevice = {
			enabled = false,
		},
		touchpad = {
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.4,
		},
		repeat_rate = 40,
		repeat_delay = 600,
		numlock_by_default = true,
	},
})

-- Custom gesture bindings
hl.gesture({
	fingers = 3,
	direction = "down",
	action = function()
		hl.dsp.exec_cmd("swaync-client -t")
	end,
})
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
