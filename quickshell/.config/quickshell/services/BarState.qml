// BarState.qml — bar visibility, toggled via `qs ipc call bar toggle`.
// Replaces Omarchy's toggle-waybar (pkill/relaunch waybar), which no longer
// applies now that the bar is a QML window inside this same Quickshell
// process rather than a separate process. See bindings.lua for the
// SUPER + SHIFT + SPACE binding.
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool visible: true

    function toggle() {
        root.visible = !root.visible;
    }

    IpcHandler {
        target: "bar"

        function toggle(): void { root.toggle(); }
    }
}
