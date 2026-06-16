-- Generated from consolidated bindings.conf
local mainMod = "SUPER"
local osdclient = "swayosd-client --monitor \"$(~/.dotfiles/bin/hyprland-monitor-focused)\""

-- Multimedia keys
hl.bind({ mod = "", key = "XF86AudioRaiseVolume", action = hl.dsp.exec_cmd(osdclient .. " --output-volume raise") })
hl.bind({ mod = "", key = "XF86AudioLowerVolume", action = hl.dsp.exec_cmd(osdclient .. " --output-volume lower") })
hl.bind({ mod = "", key = "XF86AudioMute", action = hl.dsp.exec_cmd(osdclient .. " --output-volume mute-toggle") })
hl.bind({ mod = "", key = "XF86AudioMicMute", action = hl.dsp.exec_cmd("~/.dotfiles/bin/audio-input-mute") })
hl.bind({ mod = "", key = "XF86MonBrightnessUp", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display +5%") })
hl.bind({ mod = "", key = "XF86MonBrightnessDown", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display 5%-") })
hl.bind({ mod = "", key = "XF86KbdBrightnessUp", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard up") })
hl.bind({ mod = "", key = "XF86KbdBrightnessDown", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard down") })
hl.bind({ mod = "", key = "XF86KbdLightOnOff", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-keyboard cycle") })

-- Precise multimedia adjustments
hl.bind({ mod = "ALT", key = "XF86AudioRaiseVolume", action = hl.dsp.exec_cmd(osdclient .. " --output-volume +1") })
hl.bind({ mod = "ALT", key = "XF86AudioLowerVolume", action = hl.dsp.exec_cmd(osdclient .. " --output-volume -1") })
hl.bind({ mod = "ALT", key = "XF86MonBrightnessUp", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display +1%") })
hl.bind({ mod = "ALT", key = "XF86MonBrightnessDown", action = hl.dsp.exec_cmd("~/.dotfiles/bin/brightness-display 1%-") })

-- Playerctl
hl.bind({ mod = "", key = "XF86AudioNext", action = hl.dsp.exec_cmd(osdclient .. " --playerctl next") })
hl.bind({ mod = "", key = "XF86AudioPause", action = hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause") })
hl.bind({ mod = "", key = "XF86AudioPlay", action = hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause") })
hl.bind({ mod = "", key = "XF86AudioPrev", action = hl.dsp.exec_cmd(osdclient .. " --playerctl previous") })

-- Audio output switch
hl.bind({ mod = mainMod, key = "XF86AudioMute", action = hl.dsp.exec_cmd("~/.dotfiles/bin/audio-output-switch") })

-- Copy / Paste
hl.bind({ mod = mainMod, key = "C", action = hl.dsp.send_shortcut({ keys = {"CTRL", "Insert"}, target = "activewindow" }) })
hl.bind({ mod = mainMod, key = "V", action = hl.dsp.send_shortcut({ keys = {"SHIFT", "Insert"}, target = "activewindow" }) })
hl.bind({ mod = mainMod, key = "X", action = hl.dsp.send_shortcut({ keys = {"CTRL", "X"}, target = "activewindow" }) })
hl.bind({ mod = mainMod .. " CTRL", key = "V", action = hl.dsp.exec_cmd("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'") })

-- Close windows
hl.bind({ mod = mainMod, key = "Q", action = hl.dsp.close() })

-- Control tiling
hl.bind({ mod = mainMod, key = "P", action = hl.dsp.pseudo() })
hl.bind({ mod = mainMod, key = "T", action = hl.dsp.toggle_floating() })
hl.bind({ mod = mainMod, key = "F", action = hl.dsp.fullscreen({ state = 0 }) })
hl.bind({ mod = mainMod .. " CTRL", key = "F", action = hl.dsp.fullscreen_state({ state = 0, 2 }) })
hl.bind({ mod = mainMod .. " ALT", key = "F", action = hl.dsp.fullscreen({ state = 1 }) })

-- Focus
hl.bind({ mod = mainMod, key = "H", action = hl.dsp.move_focus("l") })
hl.bind({ mod = mainMod, key = "J", action = hl.dsp.move_focus("d") })
hl.bind({ mod = mainMod, key = "K", action = hl.dsp.move_focus("u") })
hl.bind({ mod = mainMod, key = "L", action = hl.dsp.move_focus("r") })

-- Workspaces
for i = 1, 10 do
  local code = 10 + (i-1) -- Adjusted for 1-based index in Lua, code:10 is 1
  hl.bind({ mod = mainMod, key = "code:" .. code, action = hl.dsp.workspace(i) })
  hl.bind({ mod = mainMod .. " SHIFT", key = "code:" .. code, action = hl.dsp.move_to_workspace(i) })
  hl.bind({ mod = mainMod .. " SHIFT ALT", key = "code:" .. code, action = hl.dsp.move_to_workspace_silent(i) })
end

-- Scratchpad
hl.bind({ mod = mainMod, key = "S", action = hl.dsp.toggle_special_workspace("scratchpad") })
hl.bind({ mod = mainMod .. " ALT", key = "S", action = hl.dsp.move_to_workspace_silent("special:scratchpad") })

-- Workspace navigation
hl.bind({ mod = mainMod, key = "TAB", action = hl.dsp.workspace("e+1") })
hl.bind({ mod = mainMod .. " SHIFT", key = "TAB", action = hl.dsp.workspace("e-1") })
hl.bind({ mod = mainMod .. " CTRL", key = "TAB", action = hl.dsp.workspace("previous") })

-- Monitor movement
hl.bind({ mod = mainMod .. " SHIFT ALT", key = "H", action = hl.dsp.move_current_workspace_to_monitor("l") })
hl.bind({ mod = mainMod .. " SHIFT ALT", key = "J", action = hl.dsp.move_current_workspace_to_monitor("d") })
hl.bind({ mod = mainMod .. " SHIFT ALT", key = "K", action = hl.dsp.move_current_workspace_to_monitor("u") })
hl.bind({ mod = mainMod .. " SHIFT ALT", key = "L", action = hl.dsp.move_current_workspace_to_monitor("r") })

-- Window swapping
hl.bind({ mod = mainMod .. " SHIFT", key = "H", action = hl.dsp.swap_window("l") })
hl.bind({ mod = mainMod .. " SHIFT", key = "J", action = hl.dsp.swap_window("d") })
hl.bind({ mod = mainMod .. " SHIFT", key = "K", action = hl.dsp.swap_window("u") })
hl.bind({ mod = mainMod .. " SHIFT", key = "L", action = hl.dsp.swap_window("r") })

-- Cycling
hl.bind({ mod = "ALT", key = "TAB", action = hl.dsp.cycle_next() })
hl.bind({ mod = "ALT SHIFT", key = "TAB", action = hl.dsp.cycle_next({ direction = "prev" }) })
hl.bind({ mod = "ALT", key = "TAB", action = hl.dsp.bring_active_to_top() })
hl.bind({ mod = "ALT SHIFT", key = "TAB", action = hl.dsp.bring_active_to_top() })

-- Resizing
hl.bind({ mod = mainMod, key = "code:20", action = hl.dsp.resize_active({ x = -100, y = 0 }) })
hl.bind({ mod = mainMod, key = "code:21", action = hl.dsp.resize_active({ x = 100, y = 0 }) })
hl.bind({ mod = mainMod .. " SHIFT", key = "code:20", action = hl.dsp.resize_active({ x = 0, y = -100 }) })
hl.bind({ mod = mainMod .. " SHIFT", key = "code:21", action = hl.dsp.resize_active({ x = 0, y = 100 }) })

-- Mouse
hl.bind({ mod = mainMod, key = "mouse_down", action = hl.dsp.workspace("e+1") })
hl.bind({ mod = mainMod, key = "mouse_up", action = hl.dsp.workspace("e-1") })
hl.bind({ mod = mainMod, key = "mouse:272", action = hl.dsp.move_window() })
hl.bind({ mod = mainMod, key = "mouse:273", action = hl.dsp.resize_window() })

-- Groups
hl.bind({ mod = mainMod, key = "G", action = hl.dsp.toggle_group() })
hl.bind({ mod = mainMod .. " ALT", key = "G", action = hl.dsp.move_out_of_group() })
hl.bind({ mod = mainMod .. " ALT", key = "H", action = hl.dsp.move_into_group("l") })
hl.bind({ mod = mainMod .. " ALT", key = "J", action = hl.dsp.move_into_group("d") })
hl.bind({ mod = mainMod .. " ALT", key = "K", action = hl.dsp.move_into_group("u") })
hl.bind({ mod = mainMod .. " ALT", key = "L", action = hl.dsp.move_into_group("r") })
hl.bind({ mod = mainMod .. " ALT", key = "TAB", action = hl.dsp.change_group_active("f") })
hl.bind({ mod = mainMod .. " ALT SHIFT", key = "TAB", action = hl.dsp.change_group_active("b") })
hl.bind({ mod = mainMod .. " CTRL", key = "H", action = hl.dsp.change_group_active("b") })
hl.bind({ mod = mainMod .. " CTRL", key = "L", action = hl.dsp.change_group_active("f") })
hl.bind({ mod = mainMod .. " ALT", key = "mouse_down", action = hl.dsp.change_group_active("f") })
hl.bind({ mod = mainMod .. " ALT", key = "mouse_up", action = hl.dsp.change_group_active("b") })

for i = 1, 5 do
  local code = 10 + (i-1)
  hl.bind({ mod = mainMod .. " ALT", key = "code:" .. code, action = hl.dsp.change_group_active(i) })
end

-- Menus & Apps
hl.bind({ mod = mainMod, key = "SPACE", action = hl.dsp.exec_cmd("rofi -show drun") })
hl.bind({ mod = mainMod .. " CTRL", key = "E", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-walker -m symbols") })
hl.bind({ mod = mainMod .. " CTRL", key = "C", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu capture") })
hl.bind({ mod = mainMod .. " CTRL", key = "O", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu toggle") })
hl.bind({ mod = mainMod .. " ALT", key = "SPACE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu") })
hl.bind({ mod = mainMod .. " SHIFT", key = "code:201", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu") })
hl.bind({ mod = mainMod, key = "ESCAPE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu system") })
hl.bind({ mod = "", key = "XF86PowerOff", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu system") })
hl.bind({ mod = mainMod, key = "PERIOD", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu-keybindings") })
hl.bind({ mod = "", key = "XF86Calculator", action = hl.dsp.exec_cmd("gnome-calculator") })

-- Aesthetics
hl.bind({ mod = mainMod .. " SHIFT", key = "SPACE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-waybar") })
hl.bind({ mod = mainMod .. " CTRL", key = "SPACE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu background") })
hl.bind({ mod = mainMod, key = "BACKSPACE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/hyprland-active-window-transparency-toggle") })

-- Notifications
hl.bind({ mod = mainMod, key = "COMMA", action = hl.dsp.exec_cmd("swaync-client --close-latest") })
hl.bind({ mod = mainMod .. " SHIFT", key = "COMMA", action = hl.dsp.exec_cmd("swaync-client --close-all") })
hl.bind({ mod = mainMod .. " CTRL", key = "COMMA", action = hl.dsp.exec_cmd("swaync-client -d") })
hl.bind({ mod = mainMod .. " CTRL ALT", key = "COMMA", action = hl.dsp.exec_cmd("swaync-client -t") })

-- Toggles
hl.bind({ mod = mainMod .. " CTRL", key = "I", action = hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-idle") })
hl.bind({ mod = mainMod .. " CTRL", key = "N", action = hl.dsp.exec_cmd("~/.dotfiles/bin/toggle-nightlight") })

-- Captures
hl.bind({ mod = "", key = "PRINT", action = hl.dsp.exec_cmd("~/.dotfiles/bin/capture-screenshot") })
hl.bind({ mod = "ALT", key = "PRINT", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu screenrecord") })
hl.bind({ mod = mainMod, key = "PRINT", action = hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a") })

-- File sharing
hl.bind({ mod = mainMod .. " CTRL", key = "S", action = hl.dsp.exec_cmd("~/.dotfiles/bin/menu share") })

-- Control panels
hl.bind({ mod = mainMod .. " CTRL", key = "A", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-audio") })
hl.bind({ mod = mainMod .. " CTRL", key = "B", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-bluetooth") })
hl.bind({ mod = mainMod .. " CTRL", key = "W", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-wifi") })
hl.bind({ mod = mainMod .. " CTRL", key = "T", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui btop") })

-- Dictation
hl.bind({ mod = mainMod .. " CTRL", key = "X", action = hl.dsp.exec_cmd("voxtype record toggle") })

-- Zoom
hl.bind({ mod = mainMod .. " CTRL", key = "Z", action = hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float + 1')") })
hl.bind({ mod = mainMod .. " CTRL ALT", key = "Z", action = hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1") })

-- Lock system
hl.bind({ mod = mainMod .. " CTRL", key = "L", action = hl.dsp.exec_cmd("~/.dotfiles/bin/system-lock") })

-- Apps
hl.bind({ mod = mainMod, key = "RETURN", action = hl.dsp.exec_cmd("uwsm-app -- ghostty +new-window") })
hl.bind({ mod = mainMod .. " SHIFT", key = "RETURN", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-browser") })
hl.bind({ mod = mainMod .. " SHIFT", key = "F", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui yazi") })
hl.bind({ mod = mainMod .. " SHIFT", key = "B", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-browser") })
hl.bind({ mod = mainMod .. " SHIFT", key = "M", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-or-focus spotify") })
hl.bind({ mod = mainMod .. " SHIFT", key = "N", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-editor") })
hl.bind({ mod = mainMod .. " SHIFT", key = "D", action = hl.dsp.exec_cmd("~/Desktop/appimages/drawy.AppImage") })
hl.bind({ mod = mainMod .. " SHIFT", key = "T", action = hl.dsp.exec_cmd("uwsm-app -- typora --enable-wayland-ime") })
hl.bind({ mod = mainMod .. " SHIFT", key = "SLASH", action = hl.dsp.exec_cmd("uwsm-app -- 1password") })
hl.bind({ mod = mainMod .. " SHIFT ALT", key = "B", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-browser --private") })
hl.bind({ mod = "CTRL SHIFT", key = "ESCAPE", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-tui btop") })

-- Web Apps
hl.bind({ mod = mainMod .. " SHIFT", key = "C", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-webapp \"https://calendar.notion.so\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "E", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-webapp \"https://mail.notion.so\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "Y", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-webapp \"https://youtube.com/\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "W", action = hl.dsp.exec_cmd("~/.dotfiles/bin/launch-or-focus-webapp WhatsApp \"https://web.whatsapp.com/\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "C", action = hl.dsp.exec_cmd("omarchy-launch-webapp \"https://calendar.notion.so\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "E", action = hl.dsp.exec_cmd("omarchy-launch-webapp \"https://mail.notion.so\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "Y", action = hl.dsp.exec_cmd("omarchy-launch-webapp \"https://youtube.com/\"") })
hl.bind({ mod = mainMod .. " SHIFT", key = "W", action = hl.dsp.exec_cmd("omarchy-launch-or-focus-webapp WhatsApp \"https://web.whatsapp.com/\"") })
