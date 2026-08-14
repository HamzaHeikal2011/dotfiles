// BatteryPanel.qml — popup content for BatteryIndicator. Shows the detail
// UPower already gives us for free, plus power-profile switching via
// power-profiles-daemon (already initialized at login, see
// hypr/autostart.lua's powerprofiles-init call).
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "../"

ColumnLayout {
    id: root

    required property var device
    required property bool ready
    required property int pct
    required property bool charging

    spacing: 10

    Text {
        text: root.ready ? (root.pct + "%") : "No battery"
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: 22
        font.weight: Theme.fontWeight
    }

    Text {
        visible: root.ready
        text: {
            if (!root.ready) return "";
            const rate = Math.abs(root.device.changeRate).toFixed(1) + "W";
            const state = root.charging ? "Charging" : "Discharging";
            const time = root.charging ? root.device.timeToFull : root.device.timeToEmpty;
            if (time > 0) {
                const mins = Math.round(time / 60);
                const h = Math.floor(mins / 60), m = mins % 60;
                return state + " · " + rate + " · " + h + "h " + m + "m left";
            }
            return state + " · " + rate;
        }
        color: Theme.muted
        font.family: Theme.fontFamily
        font.pixelSize: 12
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Text {
        text: "Power profile"
        color: Theme.muted
        font.family: Theme.fontFamily
        font.pixelSize: 11
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Repeater {
            model: [
                { key: "power-saver", label: "Saver" },
                { key: "balanced", label: "Balanced" },
                { key: "performance", label: "Performance" }
            ]

            Rectangle {
                required property var modelData
                readonly property bool active: profileProc.currentProfile === modelData.key

                Layout.fillWidth: true
                implicitHeight: 28
                radius: 6
                color: active ? Theme.foreground : "transparent"
                border.width: 1
                border.color: active ? Theme.foreground : Theme.inactiveBorder

                Text {
                    anchors.centerIn: parent
                    text: parent.modelData.label
                    color: parent.active ? Theme.background : Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: profileProc.setProfile(parent.modelData.key)
                }
            }
        }
    }

    Item { Layout.fillHeight: true }

    QtObject {
        id: profileProc
        property string currentProfile: ""

        function setProfile(key) {
            setProc.command = ["powerprofilesctl", "set", key];
            setProc.running = true;
            profileProc.currentProfile = key;
        }
    }

    Process {
        id: getProc
        command: ["powerprofilesctl", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: profileProc.currentProfile = this.text.trim()
        }
    }

    Process {
        id: setProc
    }
}
