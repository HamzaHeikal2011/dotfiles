// TrayModule.qml — mirrors waybar's "group/tray-expander" (expand icon + tray).
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../"
import "../components"

RowLayout {
    id: root

    // Needed so tray item context menus can be positioned relative to the bar.
    required property var barWindow

    property bool expanded: false
    spacing: 4

    BarButton {
        label: ""
        iconMode: true
        onLeftClicked: root.expanded = !root.expanded

        rotation: root.expanded ? 180 : 0
        Behavior on rotation {
            NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType }
        }
    }

    Item {
        id: drawer
        clip: true
        implicitHeight: Theme.barHeight - 10
        implicitWidth: root.expanded ? trayRow.implicitWidth : 0

        Behavior on implicitWidth {
            NumberAnimation { duration: Theme.animSlow; easing.type: Theme.easeType }
        }

        RowLayout {
            id: trayRow
            height: parent.height
            spacing: 10

            Repeater {
                model: SystemTray.items

                Image {
                    required property var modelData

                    Layout.alignment: Qt.AlignVCenter
                    sourceSize.width: 14
                    sourceSize.height: 14
                    source: modelData.icon

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -4
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton) {
                                modelData.activate();
                            } else if (mouse.button === Qt.MiddleButton) {
                                modelData.secondaryActivate();
                            } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                modelData.display(root.barWindow, mouse.x, mouse.y);
                            }
                        }
                    }
                }
            }
        }
    }
}
