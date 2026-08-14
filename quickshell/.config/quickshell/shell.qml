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

    // Single instance — toasts render on the primary screen regardless of
    // which monitor triggered them.
    ToastWindow {}
}
