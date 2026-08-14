// NetworkIndicator.qml — mirrors waybar's "network" module.
// Quickshell has no built-in network singleton, so this polls nmcli the same
// way waybar's own network module effectively summarizes NetworkManager state.
import Quickshell.Io
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    property var popupScreen: null

    iconMode: true
    label: icon
    tooltipText: tooltip

    property string icon: "󰤮"
    property string tooltip: "Disconnected"

    readonly property var wifiIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]

    onLeftClicked: popup.open = !popup.open
    onRightClicked: launchProc.running = true

    Process {
        id: pollProc
        // TYPE,STATE for the primary connected device; SIGNAL for wifi.
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device status | awk -F: '$2==\"connected\"{print; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = this.text.trim();
                if (!line) {
                    root.icon = "󰤮";
                    root.tooltip = "Disconnected";
                    return;
                }
                const parts = line.split(":");
                const type = parts[0] ?? "";
                const conn = parts[2] ?? "";
                if (type === "ethernet") {
                    root.icon = "󰀂";
                    root.tooltip = "Connected (" + conn + ")";
                } else if (type === "wifi") {
                    root.tooltip = conn;
                    signalProc.running = true;
                } else {
                    root.icon = "󰀂";
                    root.tooltip = conn || "Connected";
                }
            }
        }
    }

    Process {
        id: signalProc
        command: ["sh", "-c", "nmcli -t -f active,signal dev wifi | awk -F: '$1==\"yes\"{print $2; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const signal = parseInt(this.text.trim());
                if (isNaN(signal)) {
                    root.icon = root.wifiIcons[0];
                    return;
                }
                const idx = Math.min(root.wifiIcons.length - 1, Math.floor(signal / 25));
                root.icon = root.wifiIcons[idx];
            }
        }
    }

    Process {
        id: launchProc
        command: ["sh", "-c", "~/.dotfiles/bin/launch-wifi"]
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }

    Popup {
        id: popup
        targetScreen: root.popupScreen
        panelWidth: 320
        panelHeight: 280
        content: NetworkPanel { open: popup.open }
    }
}
