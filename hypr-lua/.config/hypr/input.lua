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
  gestures = {
    workspace_swipe = true,
    workspace_swipe_fingers = 3,
  },
})

-- Custom gesture bindings
hl.bind_gesture({ fingers = 3, direction = "down", action = hl.dsp.exec_cmd("swaync-client -t") })
