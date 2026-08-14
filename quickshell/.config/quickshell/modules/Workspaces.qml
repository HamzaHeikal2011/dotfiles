// Workspaces.qml — mirrors bindings.lua's SUPER+1..0 workspace bindings.
// Only renders workspaces Hyprland currently knows about (i.e. ones that
// have been visited/created and, per Hyprland's own default behaviour,
// still have windows or are the active one) — same effective result as
// waybar's "persistent-workspaces": {} (empty = no forced-persistent list).
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../"

RowLayout {
    id: root
    spacing: 4

    // Real workspaces only (drop special/scratchpad workspaces, which
    // Hyprland gives negative ids), sorted left-to-right by id.
    readonly property var sortedWorkspaces: {
        const arr = Hyprland.workspaces.values.filter(w => w.id > 0);
        arr.sort((a, b) => a.id - b.id);
        return arr;
    }

    Repeater {
        model: root.sortedWorkspaces

        Rectangle {
            id: pill
            required property var modelData

            readonly property int wsId: modelData.id
            readonly property bool isActive: Hyprland.focusedWorkspace?.id === wsId

            Layout.alignment: Qt.AlignVCenter
            implicitWidth: isActive ? 22 : 12
            implicitHeight: 12
            radius: 6
            color: isActive ? Theme.foreground : Theme.muted

            Behavior on implicitWidth {
                NumberAnimation { duration: Theme.animNormal; easing.type: Theme.easeTypeEmphasized }
            }
            Behavior on color {
                ColorAnimation { duration: Theme.animNormal }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + pill.wsId)
            }
        }
    }
}
