// ScreenRecordingIndicator.qml — mirrors waybar's "custom/screenrecording-indicator".
// Polls the same indicator script waybar used, so the glyph/text it shows
// comes straight from the script rather than being guessed here.
import Quickshell.Io
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    label: lastText
    textColor: isActive ? Theme.recording : Theme.foreground
    tooltipText: lastTooltip
    visible: label.length > 0

    property string lastText: ""
    property string lastTooltip: ""
    property bool isActive: false

    onLeftClicked: captureProc.running = true

    Process {
        id: pollProc
        command: ["sh", "-c", "~/.dotfiles/sources/waybar/indicators/screen-recording.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    root.lastText = data.text ?? "";
                    root.lastTooltip = data.tooltip ?? "";
                    const cls = data.class ?? "";
                    root.isActive = Array.isArray(cls) ? cls.includes("active") : cls === "active";
                } catch (e) {
                    root.lastText = "";
                }
            }
        }
    }

    Process {
        id: captureProc
        command: ["sh", "-c", "~/.dotfiles/bin/capture-screenrecording"]
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: pollProc.running = true
    }
}
