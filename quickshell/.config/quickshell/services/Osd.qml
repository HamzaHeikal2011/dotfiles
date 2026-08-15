// Osd.qml — replaces swayosd entirely. For volume, this singleton owns the
// actual state change (swayosd-client used to do both the wpctl call *and*
// the popup — nothing else in the dotfiles adjusts volume). For brightness,
// keyboard backlight, and mic mute, the actual hardware/state change still
// happens in the existing bin/ scripts (brightness-display,
// brightness-keyboard, audio-input-mute); those just report the new value
// here for display instead of shelling out to swayosd-client.
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // "volume" | "brightness" | "kbdBacklight" | "mic"
    property string kind: ""
    property int value: 0
    property bool muted: false
    property bool active: false
    property string message: ""
    property string iconState: ""

    function show(newKind, newValue, newMuted, newMessage, newIconState) {
        root.kind = newKind;
        root.value = newValue ?? 0;
        root.muted = newMuted === true;
        root.message = newMessage ?? "";
        root.iconState = newIconState ?? "";
        root.active = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.active = false
    }

    // --- Volume: actually changes the sink, then displays the result ---
    function volumeRaise() { changeVolume("5%+"); }
    function volumeLower() { changeVolume("5%-"); }
    function volumeUp1() { changeVolume("1%+"); }
    function volumeDown1() { changeVolume("1%-"); }
    function volumeMuteToggle() { runVolumeCmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"); }

    function changeVolume(step) {
        runVolumeCmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " + step);
    }

    function runVolumeCmd(cmd) {
        volProc.command = ["sh", "-c", cmd + " && wpctl get-volume @DEFAULT_AUDIO_SINK@"];
        volProc.running = true;
    }

    Process {
        id: volProc
        stdout: StdioCollector {
            // wpctl prints e.g. "Volume: 0.45" or "Volume: 0.45 [MUTED]"
            onStreamFinished: {
                const text = this.text.trim();
                const match = text.match(/Volume:\s*([\d.]+)/);
                const pct = match ? Math.round(parseFloat(match[1]) * 100) : 0;
                root.show("volume", pct, text.includes("[MUTED]"));
            }
        }
    }

    // --- Brightness / keyboard backlight / mic: value already changed by
    // the calling script; just report it. ---
    function brightnessShow(percent) { root.show("brightness", parseInt(percent), false); }
    function kbdBacklightShow(percent) { root.show("kbdBacklight", parseInt(percent), false); }
    function micShow(muted) { root.show("mic", 0, muted === "on" || muted === "true"); }

    // Generic text confirmation — e.g. audio-output-switch's "Switched to
    // <device>" / "No audio devices found". iconState reuses the same
    // muted/low/medium/high vocabulary that script already computes.
    function messageShow(text, iconState) { root.show("message", 0, false, text, iconState); }

    IpcHandler {
        target: "osd"

        function volumeRaise(): void { root.volumeRaise(); }
        function volumeLower(): void { root.volumeLower(); }
        function volumeUp1(): void { root.volumeUp1(); }
        function volumeDown1(): void { root.volumeDown1(); }
        function volumeMuteToggle(): void { root.volumeMuteToggle(); }
        function brightnessShow(percent: string): void { root.brightnessShow(percent); }
        function kbdBacklightShow(percent: string): void { root.kbdBacklightShow(percent); }
        function micShow(muted: string): void { root.micShow(muted); }
        function messageShow(text: string, iconState: string): void { root.messageShow(text, iconState); }
    }
}
