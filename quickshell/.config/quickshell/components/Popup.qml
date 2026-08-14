// Popup.qml — shared dropdown panel used by the Network/Bluetooth/
// Notification/Battery indicators (see end-4/illogical-impulse's sidebar
// panels for the same top-right-dropdown-off-the-bar pattern this copies).
// Anchors to the top-right of `screen`, sits just under the bar, and closes
// itself on an outside click via HyprlandFocusGrab.
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import "../"

PanelWindow {
    id: popup

    // Named targetScreen (rather than overriding PanelWindow's own built-in
    // `screen` property directly) so an explicit null default doesn't fight
    // with Quickshell's fallback screen assignment.
    property var targetScreen: null
    screen: targetScreen ?? Quickshell.screens[0]

    property bool open: false
    property int panelWidth: 320
    property int panelHeight: 240
    default property alias content: contentLoader.sourceComponent

    visible: open
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:popup"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }

    margins {
        top: Theme.barHeight + 14
        right: Theme.edgeMargin
    }

    implicitWidth: panelWidth
    implicitHeight: panelHeight

    HyprlandFocusGrab {
        id: grab
        windows: [popup]
        active: popup.open
        onCleared: popup.open = false
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.background
        border.width: 1
        border.color: Theme.border
        clip: true

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.margins: 12
        }
    }
}
