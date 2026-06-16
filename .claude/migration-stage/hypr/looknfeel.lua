-- Generated from consolidated looknfeel.conf
local activeBorderColor = "rgba(33ccffee) rgba(00ff99ee) 45deg"
local inactiveBorderColor = "rgba(595959aa)"

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
    blur = {
      enabled = true,
      size = 2,
      passes = 2,
      special = true,
      brightness = 0.60,
      contrast = 0.75,
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
    bezier = {
      easeOutQuint = { 0.23, 1, 0.32, 1 },
      easeInOutCubic = { 0.65, 0.05, 0.36, 1 },
      linear = { 0, 0, 1, 1 },
      almostLinear = { 0.5, 0.5, 0.75, 1.0 },
      quick = { 0.15, 0, 0.1, 1 },
    },
    animation = {
      global = { 1, 10, "default" },
      border = { 1, 5.39, "easeOutQuint" },
      windows = { 1, 4.79, "easeOutQuint" },
      windowsIn = { 1, 4.1, "easeOutQuint", "popin 87%" },
      windowsOut = { 1, 1.49, "linear", "popin 87%" },
      fadeIn = { 1, 1.73, "almostLinear" },
      fadeOut = { 1, 1.46, "almostLinear" },
      fade = { 1, 3.03, "quick" },
      layers = { 1, 3.81, "easeOutQuint" },
      layersIn = { 1, 4, "easeOutQuint", "fade" },
      layersOut = { 1, 1.5, "linear", "fade" },
      fadeLayersIn = { 1, 1.79, "almostLinear" },
      fadeLayersOut = { 1, 1.39, "almostLinear" },
      workspaces = { 0, 0, "ease" },
      specialWorkspace = { 1, 4, "easeOutQuint", "slidevert" },
    },
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

-- Environment variables from looknfeel
hl.env("GUM_CONFIRM_PROMPT_FOREGROUND", "6")
hl.env("GUM_CONFIRM_SELECTED_FOREGROUND", "0")
hl.env("GUM_CONFIRM_SELECTED_BACKGROUND", "2")
hl.env("GUM_CONFIRM_UNSELECTED_FOREGROUND", "7")
hl.env("GUM_CONFIRM_UNSELECTED_BACKGROUND", "8")

-- Final Overrides
activeBorderColor = "rgb(8A8A8A)"
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
    animation = {
      workspaces = { 1, 5, "easeOutQuint" },
    },
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

hl.layer_rule({ rule = "no_anim off", selector = "match:namespace walker" })
