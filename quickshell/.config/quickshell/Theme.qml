// Theme.qml — shared design tokens for the whole shell.
// Values below are taken directly from waybar/style.css, swayosd/style.css
// and hypr/looknfeel.lua where possible. The exact hex value behind the
// `@foreground` / `@background` CSS vars lives in
// ~/.dotfiles/theme/waybar.css, which wasn't available while writing this,
// so `foreground` / `background` below are a best-effort match to the
// dark/monochrome palette visible everywhere else (window#waybar background,
// hyprlock, tray tooltip). Tweak these two if they don't match exactly.
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // --- Core palette (from waybar.css / swayosd style.css) ---
    readonly property color background: "#121212"
    readonly property color backgroundAlt: "#0f0f0f"
    readonly property color foreground: "#e0e0e0"
    readonly property color muted: "#9a9a9a"
    readonly property color border: "#80808080" // rgba(128,128,128,0.5)
    readonly property color activeBorder: "#8a8a8a" // hypr looknfeel active border
    readonly property color inactiveBorder: "#2a2a2a"

    // --- Status colors (from waybar.css battery/recording states) ---
    readonly property color warning: "#c55a5a"
    readonly property color critical: "#f38ba8"
    readonly property color recording: "#a55555"
    readonly property color accent: "cornflowerblue"

    readonly property color tooltipBg: "#0f0f0f"

    // --- Typography ---
    readonly property string fontFamily: "CaskaydiaMono Nerd Font"
    readonly property int fontSize: 13
    readonly property int fontWeight: Font.DemiBold

    // --- Shape / layout ---
    readonly property int radius: 12
    readonly property int barHeight: 32
    readonly property int barWidth: 650 // matches waybar's fixed "width": 650
    readonly property int edgeMargin: 10 // symmetric left/right inset, matches waybar spacing
    readonly property int moduleSpacing: 2
    readonly property int innerPad: 6

    // --- Icon buttons (network/bluetooth/notification/battery/tray-toggle) ---
    // These are single-glyph BarButtons; fixing both the font size and the
    // button box to the same values keeps them visually uniform regardless
    // of how wide any individual Nerd Font glyph happens to be.
    readonly property int iconFontSize: 13
    readonly property int iconButtonSize: barHeight - 14

    // Slightly looser than moduleSpacing so the right-side icon cluster
    // reads as "close together" rather than "touching".
    readonly property int iconRowSpacing: 3

    // Extra, non-exclusive height reserved below the bar pill so the
    // hover-preview pill (BarButton.qml) has somewhere to render into
    // without being clipped by the window's own surface bounds.
    readonly property int hoverPreviewHeadroom: 40

    // --- Motion (approximating hypr's easeOutQuint bezier(0.23,1,0.32,1)) ---
    readonly property int animFast: 120
    readonly property int animNormal: 200
    readonly property int animSlow: 400
    readonly property int easeType: Easing.OutCubic
    readonly property int easeTypeEmphasized: Easing.OutBack
}
