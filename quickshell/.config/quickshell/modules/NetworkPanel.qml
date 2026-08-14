// NetworkPanel.qml — popup content for NetworkIndicator. Wi-Fi radio
// on/off toggle, plus nearby networks with click-to-connect/disconnect.
// Anything needing a fresh password prompt (unknown secured network) still
// falls back to the existing ~/.dotfiles/bin/launch-wifi TUI (right-click
// the bar icon) since a text field in a dropdown popup is a bigger, more
// fiddly job than this pass covers.
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../"

ColumnLayout {
    id: root

    // Rescans every time the popup is opened.
    property bool open: false
    onOpenChanged: if (open) refresh()

    property var networks: []
    property bool radioOn: true
    property string status: ""

    function refresh() {
        radioProc.running = true;
        scanProc.running = true;
    }

    // nmcli connection ids can contain characters that are unsafe to splice
    // into a shell -c string directly; single-quote and escape embedded
    // single quotes rather than relying on JSON.stringify (which escapes
    // for JS, not for the shell).
    function shellQuote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'";
    }

    spacing: 8

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            text: "Wi-Fi"
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: 15
            font.weight: Theme.fontWeight
        }

        Rectangle {
            implicitWidth: 40
            implicitHeight: 22
            radius: 11
            color: root.radioOn ? Theme.foreground : Theme.inactiveBorder

            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: Theme.background
                anchors.verticalCenter: parent.verticalCenter
                x: root.radioOn ? parent.width - width - 3 : 3
                Behavior on x { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.radioOn = !root.radioOn;
                    radioToggleProc.command = ["sh", "-c", "nmcli radio wifi " + (root.radioOn ? "on" : "off")];
                    radioToggleProc.running = true;
                    root.status = root.radioOn ? "Turning Wi-Fi on…" : "Turning Wi-Fi off…";
                }
            }
        }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: list.implicitHeight
        clip: true
        visible: root.radioOn

        ColumnLayout {
            id: list
            width: parent.width
            spacing: 2

            Text {
                visible: root.networks.length === 0
                text: "Scanning…"
                color: Theme.muted
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Repeater {
                model: root.networks

                Rectangle {
                    id: row
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: 32
                    radius: 6
                    color: "transparent"

                    // Highlight lives in its own layer so dimming it
                    // doesn't also dim the row's text/icons on top of it.
                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Theme.foreground
                        opacity: hoverArea.containsMouse ? 0.14 : 0.0
                        Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 8

                        Text {
                            text: row.modelData.active ? "󰤨" : "󰤟"
                            color: row.modelData.active ? Theme.accent : Theme.foreground
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.iconFontSize
                        }

                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.ssid
                            color: Theme.foreground
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        Text {
                            text: row.modelData.secure ? "󰌾" : ""
                            color: Theme.muted
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                        }

                        Text {
                            text: row.modelData.active ? "Disconnect" : "Connect"
                            color: Theme.muted
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (row.modelData.active) {
                                root.status = "Disconnecting from " + row.modelData.ssid + "…";
                                connectProc.command = ["sh", "-c", "nmcli connection down id " + root.shellQuote(row.modelData.ssid)];
                            } else {
                                root.status = "Connecting to " + row.modelData.ssid + "…";
                                connectProc.command = ["sh", "-c", "nmcli device wifi connect " + root.shellQuote(row.modelData.ssid)];
                            }
                            connectProc.running = true;
                        }
                    }
                }
            }
        }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Text {
        text: root.status.length > 0 ? root.status : "New secured networks: right-click the bar icon"
        color: Theme.muted
        font.family: Theme.fontFamily
        font.pixelSize: 10
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    Process {
        id: radioProc
        command: ["sh", "-c", "nmcli radio wifi"]
        stdout: StdioCollector {
            onStreamFinished: root.radioOn = this.text.trim() === "enabled"
        }
    }

    Process {
        id: radioToggleProc
    }

    Process {
        id: scanProc
        command: ["sh", "-c", "nmcli -t -f active,ssid,security dev wifi list | awk -F: '!seen[$2]++'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n").filter(l => l.length > 0);
                root.networks = lines.map(line => {
                    const parts = line.split(":");
                    return {
                        active: parts[0] === "yes",
                        ssid: parts[1] ?? "",
                        secure: (parts[2] ?? "").length > 0 && parts[2] !== "--"
                    };
                }).filter(n => n.ssid.length > 0);
            }
        }
    }

    Process {
        id: connectProc
        onExited: (exitCode) => {
            root.status = exitCode === 0 ? "" : "That didn't work — try the advanced Wi-Fi settings (right-click)";
            scanProc.running = true;
        }
    }
}
