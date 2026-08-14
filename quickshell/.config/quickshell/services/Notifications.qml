// Notifications.qml — replaces swaync entirely. Owns the
// org.freedesktop.Notifications DBus name via Quickshell's own
// NotificationServer, keeps an in-memory history (for NotificationPanel),
// drives a toast queue (for ToastWindow), and tracks Do Not Disturb.
//
// IMPORTANT: swaync must not be running at the same time as this — only one
// process can own org.freedesktop.Notifications. See autostart.lua (the
// `swaync` exec line is removed) and bindings.lua/input.lua (swaync-client
// calls replaced with `qs ipc call notifications ...`, exposed below via
// IpcHandler — verify the exact `qs ipc` invocation syntax against your
// installed Quickshell version, since it wasn't possible to test live here).
pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property bool dnd: false
    property bool panelOpen: false

    // Plain JS objects: { id, appName, summary, body, time, urgency, read }.
    // Newest first, capped so this doesn't grow unbounded over a long
    // uptime.
    property var history: []
    readonly property int unreadCount: history.filter(n => !n.read).length

    // Mirrors the old swaync-client icon-state strings so NotificationIndicator
    // barely had to change.
    readonly property string iconState: {
        const hasUnread = unreadCount > 0;
        if (dnd) return hasUnread ? "dnd-notification" : "dnd-none";
        return hasUnread ? "notification" : "none";
    }

    // Toast queue: same shape as history entries plus expiresAt (epoch ms).
    property var toastQueue: []

    function pushToast(entry, timeoutMs) {
        const withExpiry = Object.assign({}, entry, { expiresAt: Date.now() + timeoutMs });
        toastQueue = [...toastQueue, withExpiry];
    }

    function dismissToast(id) {
        toastQueue = toastQueue.filter(t => t.id !== id);
    }

    Timer {
        // Sweeps expired toasts. 250ms is frequent enough to feel immediate
        // without being a busy-loop.
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            const now = Date.now();
            if (root.toastQueue.some(t => t.expiresAt <= now)) {
                root.toastQueue = root.toastQueue.filter(t => t.expiresAt > now);
            }
        }
    }

    function toggleDnd() {
        root.dnd = !root.dnd;
    }

    function togglePanel() {
        root.panelOpen = !root.panelOpen;
    }

    function markAllRead() {
        root.history = root.history.map(n => (n.read ? n : Object.assign({}, n, { read: true })));
    }

    function clearAll() {
        root.history = [];
        root.toastQueue = [];
        for (const n of server.trackedNotifications.values) {
            n.dismiss();
        }
    }

    function closeLatest() {
        const values = server.trackedNotifications.values;
        if (values.length > 0) {
            values[values.length - 1].dismiss();
        }
    }

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: (notification) => {
            // Keep it tracked only long enough to display/act on it; our own
            // `history` array is the source of truth after that, not the
            // server's live model.
            notification.tracked = true;

            const entry = {
                id: notification.id,
                appName: notification.appName || "Unknown",
                summary: notification.summary || "",
                body: notification.body || "",
                time: new Date().toLocaleTimeString(Qt.locale(), "h:mm AP"),
                urgency: notification.urgency,
                read: false
            };

            root.history = [entry, ...root.history].slice(0, 100);

            if (!root.dnd) {
                const timeout = notification.expireTimeout > 0 ? notification.expireTimeout : 5000;
                root.pushToast(entry, timeout);
            }
        }
    }

    IpcHandler {
        target: "notifications"

        function toggleDnd(): void { root.toggleDnd(); }
        function togglePanel(): void { root.togglePanel(); }
        function clearAll(): void { root.clearAll(); }
        function closeLatest(): void { root.closeLatest(); }
    }
}
