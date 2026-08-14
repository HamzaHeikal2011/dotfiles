// BarButton.qml — small reusable icon/text pill with hover + press animation
// and a hover-preview pill, used by the network/bluetooth/battery/voxtype/
// etc. modules.
//
// NOTE: this used to use QtQuick.Controls' ToolTip. Under a WlrLayershell
// PanelWindow, ToolTip creates its own top-level popup surface, and on this
// setup that was intercepting the click meant to open the indicator's own
// popup (hover to see the tooltip, then the click that should open the
// panel doesn't land). Replaced with a plain, non-interactive Rectangle
// that slides out from under the button instead — never a separate
// window/surface, so it can never steal the click.
import QtQuick
import "../"

Item {
    id: root

    property string label: ""
    property string tooltipText: ""
    property color textColor: Theme.foreground
    property bool hovered: mouseArea.containsMouse

    // Fixed-size "icon button" mode: used by single-glyph modules (network,
    // bluetooth, notification, battery, tray toggle) so they all occupy the
    // same square footprint instead of shrink-wrapping to whatever width
    // that particular Nerd Font glyph happens to render at.
    property bool iconMode: false

    signal leftClicked()
    signal rightClicked()
    signal middleClicked()

    implicitWidth: iconMode ? Theme.iconButtonSize : (text.implicitWidth + Theme.innerPad)
    implicitHeight: iconMode ? Theme.iconButtonSize : (Theme.barHeight - 10)

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius - 4
        color: Theme.foreground
        opacity: root.hovered ? 0.08 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.animFast; easing.type: Theme.easeType }
        }
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: root.label
        color: root.textColor
        font.family: Theme.fontFamily
        font.pixelSize: root.iconMode ? Theme.iconFontSize : Theme.fontSize
        font.weight: Theme.fontWeight

        Behavior on color {
            ColorAnimation { duration: Theme.animNormal }
        }
    }

    scale: mouseArea.pressed ? 0.92 : 1.0
    Behavior on scale {
        NumberAnimation { duration: Theme.animFast; easing.type: Theme.easeType }
    }

    // Hover-preview pill. Purely decorative — no MouseArea, so it can never
    // block input to anything under or behind it. Lives outside `root`'s own
    // bounds (below the button); the bar window reserves a little extra,
    // non-exclusive headroom below the pill for exactly this (see
    // Theme.hoverPreviewHeadroom / Bar.qml).
    Rectangle {
        id: preview
        visible: opacity > 0.01
        opacity: root.hovered && root.tooltipText.length > 0 ? 1.0 : 0.0

        anchors.top: parent.bottom
        anchors.topMargin: root.hovered ? 8 : 2
        anchors.horizontalCenter: parent.horizontalCenter

        radius: Theme.radius - 4
        color: Theme.background
        border.width: 1
        border.color: Theme.border

        implicitWidth: previewText.implicitWidth + 16
        implicitHeight: 22
        z: 100

        Behavior on opacity {
            NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeType }
        }
        Behavior on anchors.topMargin {
            NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeTypeEmphasized }
        }

        Text {
            id: previewText
            anchors.centerIn: parent
            text: root.tooltipText
            color: Theme.foreground
            font.family: Theme.fontFamily
            font.pixelSize: 11
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) root.leftClicked();
            else if (mouse.button === Qt.RightButton) root.rightClicked();
            else if (mouse.button === Qt.MiddleButton) root.middleClicked();
        }
    }
}

