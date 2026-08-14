// IdleIndicator.qml — mirrors waybar's "custom/idle-indicator".
import Quickshell.Io
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    label: lastText
    tooltipText: lastTooltip
    visible: label.length > 0

    property string lastText: ""
    property string lastTooltip: ""

    onLeftClicked: toggleProc.running = true

    Process {
        id: pollProc
        command: ["sh", "-c", "~/.dotfiles/sources/waybar/indicators/idle.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    root.lastText = data.text ?? "";
                    root.lastTooltip = data.tooltip ?? "";
                } catch (e) {
                    root.lastText = "";
                }
            }
        }
    }

    Process {
        id: toggleProc
        command: ["sh", "-c", "~/.dotfiles/bin/toggle-idle"]
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }
}
