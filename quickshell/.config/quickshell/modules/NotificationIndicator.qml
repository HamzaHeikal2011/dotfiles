// NotificationIndicator.qml — mirrors waybar's "custom/notification"
// module, but backed by Quickshell's own Notifications singleton
// (services/Notifications.qml) instead of polling swaync-client. No swaync
// process needs to be running at all now — see autostart.lua.
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    property var popupScreen: null

    readonly property var icons: ({
        "notification": "󱅫",
        "none": "󰂜",
        "dnd-notification": "󰂠",
        "dnd-none": "󰪓"
    })

    iconMode: true
    label: icons[Notifications.iconState] ?? "󰂜"
    tooltipText: Notifications.unreadCount > 0 ? (Notifications.unreadCount + " unread") : ""

    onLeftClicked: {
        Notifications.togglePanel();
        if (Notifications.panelOpen) Notifications.markAllRead();
    }
    onRightClicked: Notifications.toggleDnd()

    Popup {
        id: popup
        targetScreen: root.popupScreen
        panelWidth: 320
        panelHeight: 360
        content: NotificationPanel {}
    }

    // Two plain (imperative, not declarative-bound) properties kept in sync
    // both ways: Popup's own outside-click handler assigns `popup.open`
    // directly, which would silently sever a one-way `open: Notifications.
    // panelOpen` binding the moment that first happens. Syncing imperatively
    // in both directions avoids that.
    Connections {
        target: Notifications
        function onPanelOpenChanged() {
            if (popup.open !== Notifications.panelOpen) popup.open = Notifications.panelOpen;
        }
    }
    Connections {
        target: popup
        function onOpenChanged() {
            if (Notifications.panelOpen !== popup.open) Notifications.panelOpen = popup.open;
        }
    }
}
