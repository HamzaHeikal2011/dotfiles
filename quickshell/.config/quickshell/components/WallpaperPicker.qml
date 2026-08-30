// WallpaperPicker.qml — the "menu with previews" triggered by
// SUPER + SHIFT + W (see bindings.lua). Single instance, centered overlay,
// dismissed by an outside click via HyprlandFocusGrab — same dismissal
// pattern as Popup.qml, just centered instead of anchored to a corner.
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../"

PanelWindow {
    id: picker

    screen: Quickshell.screens[0]

    visible: Wallpaper.pickerOpen
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:wallpaper-picker"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    HyprlandFocusGrab {
        windows: [picker]
        active: Wallpaper.pickerOpen
        onCleared: Wallpaper.pickerOpen = false
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: Math.min(parent.width - 80, 720)
        height: Math.min(parent.height - 80, grid.implicitHeight + 60)
        radius: Theme.radius
        color: Theme.background
        border.width: 1
        border.color: Theme.border

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            Text {
                text: "Wallpaper"
                color: Theme.foreground
                font.family: Theme.fontFamily
                font.pixelSize: 15
                font.weight: Theme.fontWeight
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: grid.implicitHeight
                clip: true

                GridLayout {
                    id: grid
                    width: parent.width
                    columns: 3
                    columnSpacing: 10
                    rowSpacing: 10

                    Repeater {
                        model: Wallpaper.wallpapers

                        Rectangle {
                            id: thumb
                            required property var modelData
                            readonly property bool active: modelData === Wallpaper.currentPath

                            Layout.fillWidth: true
                            Layout.preferredHeight: 110
                            radius: Theme.radius - 4
                            color: "transparent"
                            border.width: active ? 2 : 1
                            border.color: active ? Theme.accent : Theme.inactiveBorder
                            clip: true

                            Image {
                                anchors.fill: parent
                                anchors.margins: thumb.active ? 2 : 1
                                source: "file://" + encodeURI(thumb.modelData)
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Wallpaper.setWallpaper(thumb.modelData);
                                    Wallpaper.pickerOpen = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
