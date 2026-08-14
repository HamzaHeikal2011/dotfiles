// NotificationPanel.qml — popup content for NotificationIndicator. Now that
// Quickshell owns the notification server directly (services/
// Notifications.qml) instead of swaync, this can show real history instead
// of just DND controls.
import QtQuick
import QtQuick.Layouts
import "../"

ColumnLayout {
    id: root

    spacing: 8

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            text: "Notifications"
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: 15
            font.weight: Theme.fontWeight
        }

        Text {
            text: "DND"
            color: Notifications.dnd ? Theme.background : Theme.muted
            font.family: Theme.fontFamily
            font.pixelSize: 10
            font.weight: Theme.fontWeight

            Rectangle {
                z: -1
                anchors.fill: parent
                anchors.margins: -5
                radius: 5
                color: Notifications.dnd ? Theme.foreground : "transparent"
                border.width: Notifications.dnd ? 0 : 1
                border.color: Theme.inactiveBorder
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                cursorShape: Qt.PointingHandCursor
                onClicked: Notifications.toggleDnd()
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
            spacing: 4

            Text {
                visible: Notifications.history.length === 0
                text: "You're all caught up"
                color: Theme.muted
                font.family: Theme.fontFamily
                font.pixelSize: 12
            }

            Repeater {
                model: Notifications.history

                Rectangle {
                    id: entry
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: entryContent.implicitHeight + 16
                    radius: 6
                    color: "transparent"

                    // Unread highlight lives in its own low-opacity layer so
                    // dimming it doesn't also dim the text on top of it.
                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Theme.foreground
                        opacity: entry.modelData.read ? 0 : 0.06
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: "transparent"
                        border.width: 1
                        border.color: Theme.inactiveBorder
                    }

                    ColumnLayout {
                        id: entryContent
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 8
                        spacing: 1

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                Layout.fillWidth: true
                                text: entry.modelData.appName
                                color: Theme.muted
                                font.family: Theme.fontFamily
                                font.pixelSize: 10
                                elide: Text.ElideRight
                            }

                            Text {
                                text: entry.modelData.time
                                color: Theme.muted
                                font.family: Theme.fontFamily
                                font.pixelSize: 9
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: entry.modelData.summary
                            color: Theme.foreground
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Theme.fontWeight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }

                        Text {
                            visible: entry.modelData.body.length > 0
                            Layout.fillWidth: true
                            text: entry.modelData.body
                            color: Theme.muted
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }

    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.inactiveBorder }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 26
        radius: 6
        border.width: 1
        border.color: Theme.inactiveBorder
        color: "transparent"
        visible: Notifications.history.length > 0

        Text {
            anchors.centerIn: parent
            text: "Clear all"
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Notifications.clearAll()
        }
    }
}
