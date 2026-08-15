// OsdWindow.qml — replaces swayosd's popup. Single instance (see
// shell.qml), same "only exists on screen while active" shape as
// ToastWindow — exclusionMode: Ignore, driven entirely by Osd.active.
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../"

PanelWindow {
    id: osd

    screen: Quickshell.screens[0]

    visible: Osd.active
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:osd"
    exclusionMode: ExclusionMode.Ignore

    anchors { bottom: true }
    margins.bottom: 80

    implicitWidth: 260
    implicitHeight: 64

    readonly property var volumeIcons: ["󰕿", "󰖀", "󰕾"]

    readonly property string icon: {
        if (Osd.kind === "volume") {
            if (Osd.muted) return "󰝟";
            return volumeIcons[Math.min(2, Math.floor(Osd.value / 34))];
        }
        if (Osd.kind === "brightness") return "󰃟";
        if (Osd.kind === "kbdBacklight") return "󰥻";
        if (Osd.kind === "mic") return Osd.muted ? "󰍭" : "󰍬";
        return "";
    }

    readonly property string label: Osd.kind === "mic" ? (Osd.muted ? "Mic muted" : "Mic on") : (Osd.value + "%")
    readonly property bool showBar: Osd.kind !== "mic"

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.background
        border.width: 1
        border.color: Theme.border

        opacity: osd.visible ? 1 : 0
        scale: osd.visible ? 1 : 0.92
        Behavior on opacity { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType } }
        Behavior on scale { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType } }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            Text {
                text: osd.icon
                color: (Osd.kind === "mic" && Osd.muted) ? Theme.critical : Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconFontSize + 4
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: osd.label
                    color: Theme.foreground
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.weight: Theme.fontWeight
                }

                Rectangle {
                    visible: osd.showBar
                    Layout.fillWidth: true
                    implicitHeight: 4
                    radius: 2
                    color: Theme.inactiveBorder

                    Rectangle {
                        width: parent.width * (Osd.value / 100)
                        height: parent.height
                        radius: 2
                        color: Osd.muted ? Theme.muted : Theme.foreground
                        Behavior on width { NumberAnimation { duration: Theme.animFast } }
                    }
                }
            }
        }
    }
}
