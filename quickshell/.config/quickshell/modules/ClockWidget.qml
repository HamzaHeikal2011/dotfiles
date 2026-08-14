// ClockWidget.qml — mirrors waybar's "clock" module (12h format + right-click tz-select).
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../"

Item {
    id: root
    implicitWidth: label.implicitWidth + Theme.innerPad
    implicitHeight: Theme.barHeight - 8

    property string timeText: ""
    property string dateText: ""

    Text {
        id: label
        anchors.centerIn: parent
        text: root.timeText
        color: Theme.foreground
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
    }

    ToolTip.text: root.dateText
    ToolTip.visible: mouse.containsMouse
    ToolTip.delay: 400

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        onClicked: tzProc.running = true
    }

    Process {
        id: timeProc
        command: ["date", "+%I:%M %p"]
        stdout: StdioCollector {
            onStreamFinished: root.timeText = this.text.trim()
        }
    }

    Process {
        id: dateProc
        command: ["date", "+%A, %d %B %Y"]
        stdout: StdioCollector {
            onStreamFinished: root.dateText = this.text.trim()
        }
    }

    Process {
        id: tzProc
        command: ["sh", "-c", "~/.dotfiles/bin/launch-floating-terminal-with-presentation ~/.dotfiles/bin/tz-select"]
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            timeProc.running = true;
            // Only need the date string to change once a minute, but this is cheap.
            dateProc.running = true;
        }
    }
}
