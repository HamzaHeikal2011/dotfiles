-- Main Hyprland Configuration Entry Point
-- This file orchestrates the loading of all other Lua configuration modules.

local configs = {
  "envs",
  "looknfeel",
  "input",
  "monitors",
  "windows",
  "bindings",
  "autostart",
  "hyprlock",
  "hypridle",
  "hyprsunset",
  "xdph",
}

for _, config in ipairs(configs) do
  local status, err = pcall(function()
    -- Assuming hl provides a way to load other modules or we use require
    -- Given the existing files use 'hl' global, we just execute them.
    require("hypr." .. config)
  end)
  if not status then
    print("Error loading config " .. config .. ": " .. err)
  end
end
