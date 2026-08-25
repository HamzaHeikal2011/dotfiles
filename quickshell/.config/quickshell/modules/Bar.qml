// Bar.qml — one instance of this is created per screen by shell.qml.
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../"

PanelWindow {
    id: bar

    // screen + modelData are set by the Variants delegate in shell.qml
    required property var modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight + 8 + Theme.hoverPreviewHeadroom
    color: "transparent"
    // Only the actual bar pill (Theme.barHeight + 8) should be reserved
    // screen space; the extra height below it is just headroom so the
    // hover-preview pill (see BarButton.qml) isn't clipped by the window's
    // own surface bounds. exclusionMode: Normal + a manual exclusiveZone
    // keeps that headroom from pushing other windows down.
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.exclusiveZone: Theme.barHeight + 8
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:bar"

    // Without this, the whole 80px-tall window (bar pill + hover-preview
    // headroom) is clickable, even where it's fully transparent. Since this
    // layer sits above normal windows, that dead zone silently ate clicks
    // meant for whatever was underneath it (e.g. a maximized browser's tab
    // bar) all the way down to y=headroom, not just under the visible pill.
    // Restricting the mask to `surface` lets clicks in the transparent
    // region pass through to the window below instead.
    mask: Region { item: surface }

    // The visible pill — matches window#waybar { background:#121212; border-radius:8px; border:1px solid rgba(128,128,128,.5) }
    Rectangle {
        id: surface
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        width: Theme.barWidth
        height: Theme.barHeight
        radius: 8
        color: Theme.background
        border.width: 1
        border.color: Theme.border

        RowLayout {
            id: leftRegion
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.edgeMargin
            spacing: Theme.moduleSpacing

            Workspaces {}
        }

        RowLayout {
            id: centerRegion
            anchors.centerIn: parent
            spacing: Theme.moduleSpacing

            ClockWidget {}
            VoxtypeIndicator {}
            ScreenRecordingIndicator {}
            IdleIndicator {}
        }

        RowLayout {
            id: rightRegion
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: Theme.edgeMargin
            spacing: Theme.iconRowSpacing

            TrayModule { barWindow: bar }
            NetworkIndicator { popupScreen: bar.screen }
            BluetoothIndicator { popupScreen: bar.screen }
            NotificationIndicator { popupScreen: bar.screen }
            BatteryIndicator { popupScreen: bar.screen }
        }
    }
}
