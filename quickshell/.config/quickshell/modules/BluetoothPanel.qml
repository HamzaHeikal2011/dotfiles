// BluetoothPanel.qml — popup content for BluetoothIndicator. Lists known
// devices from Quickshell's native Bluetooth/BlueZ binding and lets you
// toggle connection state directly.
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import "../"

ColumnLayout {
    id: root

    required property var adapter

    spacing: 8

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            text: "Bluetooth"
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: 15
            font.weight: Theme.fontWeight
        }

        Rectangle {
            implicitWidth: 40
            implicitHeight: 22
            radius: 11
            color: (root.adapter && root.adapter.enabled) ? Theme.foreground : Theme.inactiveBorder

            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: Theme.background
                anchors.verticalCenter: parent.verticalCenter
                x: (root.adapter && root.adapter.enabled) ? parent.width - width - 3 : 3
                Behavior on x { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (root.adapter) root.adapter.enabled = !root.adapter.enabled
            }
        }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: list.implicitHeight
        clip: true

        ColumnLayout {
            id: list
            width: parent.width
            spacing: 2

            Text {
                visible: !root.adapter || root.adapter.devices.values.length === 0
                text: root.adapter ? "No known devices" : "No adapter"
                color: Theme.muted
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Repeater {
                model: root.adapter ? root.adapter.devices.values : []

                Rectangle {
                    id: row
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: 32
                    radius: 6
                    color: "transparent"

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
                            text: row.modelData.connected ? "󰂱" : "󰂯"
                            color: row.modelData.connected ? Theme.accent : Theme.muted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.iconFontSize
                        }

                        Text {
                            Layout.fillWidth: true
                            text: row.modelData.name || row.modelData.deviceName || "Unknown device"
                            color: Theme.foreground
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        Text {
                            text: row.modelData.connected ? "Disconnect" : "Connect"
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
                            if (row.modelData.connected) row.modelData.disconnect();
                            else row.modelData.connect();
                        }
                    }
                }
            }
        }
    }
}
