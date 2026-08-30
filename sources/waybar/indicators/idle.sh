#!/bin/bash
# Polled by quickshell/.config/quickshell/modules/IdleIndicator.qml every 1.5s.
# Outputs JSON: {"text": ..., "tooltip": ...}. Empty text hides the indicator
# (see IdleIndicator.qml's `visible: label.length > 0`).
#
# Shown only when idle-locking is OFF, as a "your screen won't auto-lock"
# reminder — tweak the icon/copy or invert the condition if you'd rather it
# show when locking is ON instead.

if pgrep -x hypridle >/dev/null; then
  echo '{"text": "", "tooltip": ""}'
else
  echo '{"text": "󰛊", "tooltip": "Idle lock disabled"}'
fi
