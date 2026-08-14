// BluetoothIndicator.qml — mirrors waybar's "bluetooth" module, backed by
// Quickshell's native Bluetooth/BlueZ integration instead of a poll script.
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    property var popupScreen: null

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property int connectedCount: {
        if (!adapter) return 0;
        let count = 0;
        for (const dev of adapter.devices.values) {
            if (dev.connected) count++;
        }
        return count;
    }

    // Previously this fell through to an empty string ("") for the
    // "adapter on, nothing connected" case, which is why the icon looked
    // inconsistent/missing next to the others. Now it always renders a
    // glyph; connected vs idle is conveyed by color instead.
    iconMode: true
    label: (!adapter || !adapter.enabled) ? "󰂲" : "󰂱"
    textColor: {
        if (!adapter || !adapter.enabled) return Theme.muted;
        return connectedCount > 0 ? Theme.foreground : Theme.muted;
    }
    tooltipText: (!adapter || !adapter.enabled) ? "Bluetooth off" : ("Devices connected: " + connectedCount)

    onLeftClicked: popup.open = !popup.open
    onRightClicked: launchProc.running = true

    Process {
        id: launchProc
        command: ["sh", "-c", "~/.dotfiles/bin/launch-bluetooth"]
    }

    Popup {
        id: popup
        targetScreen: root.popupScreen
        panelWidth: 300
        panelHeight: 260
        content: BluetoothPanel { adapter: root.adapter }
    }
}
