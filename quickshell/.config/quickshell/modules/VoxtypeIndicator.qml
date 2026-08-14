// VoxtypeIndicator.qml — mirrors waybar's "custom/voxtype" module.
// Reuses the same script (~/.dotfiles/bin/voxtype-status) so we don't have
// to guess at its JSON shape beyond the {alt, tooltip} contract waybar's
// format-icons mapping already implies.
import Quickshell.Io
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    readonly property var icons: ({
        "idle": "",
        "recording": "󰍬",
        "transcribing": "󰔟"
    })

    label: icons[voxState] ?? ""
    textColor: voxState === "recording" ? Theme.recording : Theme.foreground
    tooltipText: lastTooltip

    property string voxState: "idle"
    property string lastTooltip: ""

    onLeftClicked: modelProc.running = true
    onRightClicked: configProc.running = true

    Process {
        id: statusProc
        command: ["sh", "-c", "~/.dotfiles/bin/voxtype-status"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    root.voxState = data.alt ?? data.text ?? "idle";
                    root.lastTooltip = data.tooltip ?? "";
                } catch (e) {
                    // leave last-known voxState on parse failure
                }
            }
        }
    }

    Process {
        id: modelProc
        command: ["sh", "-c", "~/.dotfiles/bin/voxtype-model"]
    }

    Process {
        id: configProc
        command: ["sh", "-c", "~/.dotfiles/bin/voxtype-config"]
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusProc.running = true
    }
}
