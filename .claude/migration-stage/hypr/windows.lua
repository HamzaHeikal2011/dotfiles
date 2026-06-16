-- Generated from consolidated windows.conf
hl.window_rule({ rule = "suppress_event maximize", selector = "match:class .*" })
hl.window_rule({ rule = "tag +default-opacity", selector = "match:class .*" })
hl.window_rule({ rule = "no_focus on", selector = "match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0" })
hl.window_rule({ rule = "opacity 0.97 0.9", selector = "match:tag default-opacity" })
