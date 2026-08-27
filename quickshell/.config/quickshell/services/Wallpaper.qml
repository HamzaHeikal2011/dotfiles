// Wallpaper.qml — replaces swaybg. Scans ~/.dotfiles/theme/backgrounds/ for
// images, tracks the current selection, and persists it to a small state
// file so the choice survives a Quickshell restart (swaybg had no such
// state — it always launched with whatever path was hardcoded in
// autostart.lua). WallpaperWindow.qml renders `currentPath` fullscreen per
// screen; WallpaperPicker.qml lets you change it.
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string backgroundsDir: Quickshell.env("HOME") + "/.dotfiles/theme/backgrounds"
    readonly property string stateFile: Quickshell.env("HOME") + "/.cache/quickshell/wallpaper"

    property string currentPath: ""
    property var wallpapers: []
    property bool pickerOpen: false

    function togglePicker() {
        root.pickerOpen = !root.pickerOpen;
    }

    function setWallpaper(path) {
        root.currentPath = path;
        writeStateProc.command = ["sh", "-c", "mkdir -p ~/.cache/quickshell && printf '%s' " + shellQuote(path) + " > " + shellQuote(root.stateFile)];
        writeStateProc.running = true;
    }

    function shellQuote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'";
    }

    Component.onCompleted: {
        scanProc.running = true;
        readStateProc.running = true;
    }

    // Lists image files directly in backgroundsDir (non-recursive — matches
    // what swaybg's single hardcoded path implied: a flat folder of wallpapers).
    Process {
        id: scanProc
        command: ["sh", "-c", "find " + root.shellQuote(root.backgroundsDir) + " -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) | sort"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.wallpapers = this.text.trim().split("\n").filter(l => l.length > 0);
            }
        }
    }

    Process {
        id: readStateProc
        command: ["sh", "-c", "cat " + root.shellQuote(root.stateFile) + " 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const saved = this.text.trim();
                if (saved.length > 0) {
                    root.currentPath = saved;
                } else {
                    root.currentPath = root.backgroundsDir + "/bg1.png";
                }
            }
        }
    }

    Process {
        id: writeStateProc
    }

    IpcHandler {
        target: "wallpaper"

        function togglePicker(): void { root.togglePicker(); }
    }
}
