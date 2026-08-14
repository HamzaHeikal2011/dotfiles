// ToastWindow.qml — replaces swaync's toast bubbles. One instance, created
// once in shell.qml (not per-screen — it only needs to exist on whichever
// screen is primary). Only visible while Notifications.toastQueue is
// non-empty, so unlike the bar it needs no permanent reserved space —
// exclusionMode: Ignore, and the whole window just doesn't exist on screen
// when there's nothing to show.
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../"

PanelWindow {
    id: toastWindow

    property var targetScreen: null
    screen: targetScreen ?? Quickshell.screens[0]

    visible: Notifications.toastQueue.length > 0
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:toasts"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
    }
    margins {
        top: Theme.barHeight + 14
        right: Theme.edgeMargin
    }

    implicitWidth: 300
    implicitHeight: column.implicitHeight

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 6

        Repeater {
            model: Notifications.toastQueue

            Rectangle {
                id: toast
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: toastContent.implicitHeight + 20
                radius: Theme.radius - 4
                color: Theme.background
                border.width: 1
                border.color: modelData.urgency === 2 ? Theme.critical : Theme.border

                opacity: 0
                Component.onCompleted: opacity = 1
                Behavior on opacity {
                    NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType }
                }

                ColumnLayout {
                    id: toastContent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    spacing: 2

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Text {
                            Layout.fillWidth: true
                            text: toast.modelData.appName
                            color: Theme.muted
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "✕"
                            color: Theme.muted
                            font.pixelSize: 10

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -6
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Notifications.dismissToast(toast.modelData.id)
                            }
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: toast.modelData.summary
                        color: Theme.foreground
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                        font.weight: Theme.fontWeight
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: toast.modelData.body.length > 0
                        Layout.fillWidth: true
                        text: toast.modelData.body
                        color: Theme.muted
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        wrapMode: Text.WordWrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Notifications.dismissToast(toast.modelData.id)
                }
            }
        }
    }
}
