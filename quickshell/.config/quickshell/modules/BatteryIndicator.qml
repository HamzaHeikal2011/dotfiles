// BatteryIndicator.qml — mirrors waybar's "battery" module, backed by
// Quickshell's native UPower integration instead of sysfs polling.
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "../"
import "../components"

BarButton {
    id: root

    property var popupScreen: null

    readonly property var device: UPower.displayDevice
    readonly property bool ready: device && device.ready && device.isLaptopBattery

    // NOTE: Quickshell's UPowerDevice.percentage has been observed reporting
    // a 0-1 fraction rather than 0-100 here (that's the "stuck at 1%" bug —
    // Math.round(0.76) === 1). Detect the scale defensively so this keeps
    // working if that ever changes upstream.
    readonly property real rawPct: ready ? device.percentage : 0
    readonly property int pct: ready ? Math.round(rawPct <= 1 ? rawPct * 100 : rawPct) : 0
    readonly property bool charging: ready && device.state === UPowerDeviceState.Charging

    // Discharging levels, indexed by floor(pct / 10), 0-90.
    readonly property var icons: [
        "󰂎", "󰁺", "󰁻", "󰁼", "󰁽",
        "󰁾", "󰁿", "󰂀", "󰂁", "󰂂"
    ]
    // Charging counterparts, same indexing.
    readonly property var chargingIcons: [
        "󰂅", "󰢜", "󰂆", "󰂇", "󰂈",
        "󰢝", "󰂉", "󰢞", "󰂊", "󰢟"
    ]

    iconMode: true
    visible: ready
    label: ready ? iconFor(pct) : ""
    textColor: {
        if (pct <= 10 && !charging) return Theme.critical;
        if (pct <= 20 && !charging) return Theme.warning;
        return Theme.foreground;
    }
    tooltipText: {
        if (!ready) return "";
        const rate = Math.abs(device.changeRate).toFixed(1);
        return charging ? (rate + "W↑ " + pct + "%") : (rate + "W↓ " + pct + "%");
    }

    function iconFor(percentage) {
        const idx = Math.max(0, Math.min(icons.length - 1, Math.floor(percentage / 10)));
        return (root.charging ? root.chargingIcons : root.icons)[idx];
    }

    onLeftClicked: popup.open = !popup.open

    Popup {
        id: popup
        targetScreen: root.popupScreen
        panelWidth: 300
        panelHeight: 200
        content: BatteryPanel { device: root.device; ready: root.ready; pct: root.pct; charging: root.charging }
    }
}
