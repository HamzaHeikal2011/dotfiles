// NetworkPanel.qml — popup content for NetworkIndicator. Wi-Fi radio
// on/off toggle, nearby networks with click-to-connect/disconnect, an
// inline password prompt for unknown secured networks, and a "Forget"
// action for saved profiles. (Right-clicking the bar icon still launches
// the separate ~/.dotfiles/bin/launch-wifi TUI as an alternate path — that
// script's own issues are tracked separately.)
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"

ColumnLayout {
    id: root

    // Rescans every time the popup is opened.
    property bool open: false
    onOpenChanged: if (open) refresh()

    property var networks: []
    // Connection names nmcli already has a saved profile for (used to tell
    // "click to reconnect" apart from "needs a password").
    property var savedConnections: []
    property bool radioOn: true
    property string status: ""

    // ssid currently showing its inline password prompt; "" = none open.
    property string pendingSsid: ""

    function refresh() {
        radioProc.running = true;
        scanProc.running = true;
        savedProc.running = true;
    }

    function isSaved(ssid) {
        return root.savedConnections.indexOf(ssid) !== -1;
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

                ColumnLayout {
                    id: rowWrap
                    required property var modelData

                    Layout.fillWidth: true
                    spacing: 4

                    // Fires the actual nmcli connect. `password` is "" for
                    // open/saved networks (plain reconnect); non-empty when
                    // coming from the inline password prompt below.
                    function attemptConnect(password) {
                        const net = rowWrap.modelData;
                        root.status = "Connecting to " + net.ssid + "…";
                        let cmd = "nmcli device wifi connect " + root.shellQuote(net.ssid);
                        if (password.length > 0) cmd += " password " + root.shellQuote(password);
                        connectProc.command = ["sh", "-c", cmd];
                        connectProc.running = true;
                        root.pendingSsid = "";
                    }

                    Rectangle {
                        id: row

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
                                text: rowWrap.modelData.active ? "󰤨" : "󰤟"
                                color: rowWrap.modelData.active ? Theme.accent : Theme.foreground
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.iconFontSize
                            }

                            Text {
                                Layout.fillWidth: true
                                text: rowWrap.modelData.ssid
                                color: Theme.foreground
                                font.family: Theme.fontFamily
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            Text {
                                text: rowWrap.modelData.secure ? "󰌾" : ""
                                color: Theme.muted
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                            }

                            Text {
                                visible: root.isSaved(rowWrap.modelData.ssid)
                                text: "Forget"
                                color: Theme.muted
                                font.family: Theme.fontFamily
                                font.pixelSize: 10

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -4
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        const ssid = rowWrap.modelData.ssid;
                                        root.status = "Forgetting " + ssid + "…";
                                        if (root.pendingSsid === ssid) root.pendingSsid = "";
                                        forgetProc.command = ["sh", "-c", "nmcli connection delete id " + root.shellQuote(ssid)];
                                        forgetProc.running = true;
                                    }
                                }
                            }

                            Text {
                                text: rowWrap.modelData.active ? "Disconnect" : "Connect"
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
                                const net = rowWrap.modelData;
                                if (net.active) {
                                    root.status = "Disconnecting from " + net.ssid + "…";
                                    connectProc.command = ["sh", "-c", "nmcli connection down id " + root.shellQuote(net.ssid)];
                                    connectProc.running = true;
                                    root.pendingSsid = "";
                                } else if (net.secure && !root.isSaved(net.ssid)) {
                                    // Unknown secured network — no saved
                                    // profile for nmcli to fall back on, so
                                    // ask for a password instead of a blind
                                    // (guaranteed to fail) connect attempt.
                                    root.pendingSsid = root.pendingSsid === net.ssid ? "" : net.ssid;
                                } else {
                                    rowWrap.attemptConnect("");
                                }
                            }
                        }
                    }

                    // Inline password prompt, only for the row currently
                    // selected via root.pendingSsid.
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        spacing: 6
                        visible: root.pendingSsid === rowWrap.modelData.ssid

                        TextField {
                            id: pwField
                            Layout.fillWidth: true
                            placeholderText: "Password"
                            echoMode: TextInput.Password
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            color: Theme.foreground
                            focus: root.pendingSsid === rowWrap.modelData.ssid
                            background: Rectangle {
                                radius: 6
                                color: Theme.backgroundAlt
                                border.width: 1
                                border.color: Theme.inactiveBorder
                            }
                            onAccepted: {
                                rowWrap.attemptConnect(pwField.text);
                                pwField.text = "";
                            }
                        }

                        Rectangle {
                            implicitWidth: 64
                            implicitHeight: 28
                            radius: 6
                            color: Theme.foreground

                            Text {
                                anchors.centerIn: parent
                                text: "Connect"
                                color: Theme.background
                                font.family: Theme.fontFamily
                                font.pixelSize: 11
                                font.weight: Theme.fontWeight
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    rowWrap.attemptConnect(pwField.text);
                                    pwField.text = "";
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Text {
        text: root.status.length > 0 ? root.status : "Tap a network to connect"
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

    // Saved connection profiles (wifi only) — lets the UI tell "click to
    // reconnect instantly" apart from "this needs a password".
    Process {
        id: savedProc
        command: ["sh", "-c", "nmcli -t -f NAME,TYPE connection show | awk -F: '$2==\"802-11-wireless\"{print $1}'"]
        stdout: StdioCollector {
            onStreamFinished: root.savedConnections = this.text.trim().split("\n").filter(l => l.length > 0)
        }
    }

    Process {
        id: connectProc
        onExited: (exitCode) => {
            root.status = exitCode === 0 ? "" : "That didn't work — check the password and try again";
            scanProc.running = true;
            savedProc.running = true;
        }
    }

    Process {
        id: forgetProc
        onExited: (exitCode) => {
            root.status = exitCode === 0 ? "" : "Couldn't forget that network";
            scanProc.running = true;
            savedProc.running = true;
        }
    }
}
