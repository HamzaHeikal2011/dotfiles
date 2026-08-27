// shell.qml — entry point.
// Quickshell loads this file automatically for a directory-based config
// (~/.config/quickshell/shell.qml).
import Quickshell
import "modules"
import "components"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            id: bar
            screen: modelData
        }
    }

    // One per screen, same wallpaper everywhere — replaces swaybg (see
    // autostart.lua, the swaybg exec line is removed).
    Variants {
        model: Quickshell.screens

        WallpaperWindow {
            id: wallpaperWindow
            screen: modelData
        }
    }

    // Single instance — toasts render on the primary screen regardless of
    // which monitor triggered them.
    ToastWindow {}

    // Single instance — replaces swayosd. Same "primary screen regardless
    // of trigger" reasoning as ToastWindow above.
    OsdWindow {}

    // Single instance — centered overlay, toggled by SUPER + SHIFT + W
    // (see bindings.lua) via the "wallpaper" IPC target.
    WallpaperPicker {}
}
