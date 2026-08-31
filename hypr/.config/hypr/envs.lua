-- PATH is set explicitly here rather than relying on shell rc files
-- (.zprofile, .zshrc), because Hyprland's own process — and everything it
-- execs via hl.dsp.exec_cmd (including keybinds) — only inherits whatever
-- PATH it happened to launch with, which may not have gone through a login
-- shell at all depending on how Hyprland was started (display manager, TTY,
-- uwsm, etc). Without this, bare commands like `qs` can resolve fine when
-- you type them in a terminal but silently fail to be found when Hyprland
-- itself tries to exec them.
local home = os.getenv("HOME")
hl.env("PATH", "/usr/local/sbin:/usr/local/bin:/usr/bin:/sbin:/bin:" .. home .. "/.local/bin:" .. home .. "/.dotfiles/bin")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
	ecosystem = {
		no_update_news = true,
	},
})
