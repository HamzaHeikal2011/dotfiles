-- Generated from consolidated bindings.conf
local mainMod = "SUPER"
local osdclient = 'swayosd-client --monitor "$(~/.dotfiles/bin/hyprland-monitor-focused)"'

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume lower"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(osdclient .. " --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.dotfiles/bin/audio-input-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display 5%-"))
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard up"))
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard down"))
hl.bind("XF86KbdLightOnOff", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard cycle"))

-- Precise multimedia adjustments
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume +1"))
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(osdclient .. " --output-volume -1"))
hl.bind("ALT + XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display +1%"))
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display 1%-"))

-- Playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(osdclient .. " --playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(osdclient .. " --playerctl previous"))

-- Audio output switch
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("~/.dotfiles/bin/audio-output-switch"))
hl.bind("SUPER + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert", "activewindow" }))
hl.bind("SUPER + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert", "activewindow" }))
hl.bind("SUPER + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X", target = "activewindow" }))
hl.bind(
	"SUPER + CTRL + V",
	hl.dsp.exec_cmd("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'")
)

-- Close windows
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Mouse window ctrl
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window resizing
hl.bind(mainMod .. " + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
hl.bind(mainMod .. " + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))

-- Control tiling
hl.bind("SUPER + T", hl.dsp.window.float({ toggle }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ 1 }))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }))

-- Focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

-- Workspaces
for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Window swapping
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Cycling
hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
hl.bind("ALT + CTRL + TAB", hl.dsp.window.cycle_next({ "prev" }))

-- Menus & Apps
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("rofi -show window"))

-- Aesthetics
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-waybar"))

-- Notifications
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("swaync-client --close-latest"))
hl.bind("SUPER + CTRL + ALT + COMMA", hl.dsp.exec_cmd("swaync-client --close-all"))
hl.bind("SUPER + SHIFT + COMMA", hl.dsp.exec_cmd("swaync-client -d"))
hl.bind(" SUPER + CTRL + COMMA", hl.dsp.exec_cmd("swaync-client -t"))

-- Toggles
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-nightlight"))
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-idle"))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("~/.dotfiles/bin/system-lock"))

-- Captures
hl.bind("PRINT", hl.dsp.exec_cmd("~/.dotfiles/bin/capture-screenshot"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))

-- Control panels
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-audio"))
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-bluetooth"))
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-wifi"))
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui btop"))

-- Dictation
hl.bind("SUPER + CTRL + X", hl.dsp.exec_cmd("voxtype record toggle"))

-- Apps
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm-app -- ghostty +new-window"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-browser"))
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui yazi"))
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-or-focus spotify"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-editor"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui btop"))
