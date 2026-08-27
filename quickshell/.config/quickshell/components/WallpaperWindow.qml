// WallpaperWindow.qml — replaces swaybg. One instance per screen (see the
// Variants block in shell.qml, same pattern as Bar.qml). Sits on the
// Background layer, below everything else, and just renders whatever
// Wallpaper.currentPath is — instant swap, no crossfade.
import Quickshell
import Quickshell.Wayland
import QtQuick
import "../"

PanelWindow {
    id: wallpaperWindow

    required property var modelData

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "quickshell:wallpaper"

    Image {
        anchors.fill: parent
        source: Wallpaper.currentPath.length > 0 ? "file://" + Wallpaper.currentPath : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
    }
}
