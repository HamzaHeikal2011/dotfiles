-- Generated from consolidated hypridle.conf
hl.config({
  general = {
    lock_cmd = "hyprlock",
    before_sleep_cmd = "loginctl lock-session",
    after_sleep_cmd = "sleep 1 && hyprctl dispatch dpms on",
    inhibit_sleep = 3,
  },
  listeners = {
    {
      timeout = 150,
      ["on-timeout"] = "pidof hyprlock || omarchy-launch-screensaver",
    },
    {
      timeout = 151,
      ["on-timeout"] = "loginctl lock-session",
    },
    {
      timeout = 330,
      ["on-timeout"] = "brightnessctl -sd '*::kbd_backlight' set 0",
      ["on-resume"] = "brightnessctl -rd '*::kbd_backlight'",
    },
    {
      timeout = 330,
      ["on-timeout"] = "hyprctl dispatch dpms off",
      ["on-resume"] = "hyprctl dispatch dpms on && brightnessctl -r",
    },
  },
})
