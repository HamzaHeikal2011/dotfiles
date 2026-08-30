#!/bin/bash
# Polled by quickshell/.config/quickshell/modules/ScreenRecordingIndicator.qml
# every 1.5s. Outputs JSON: {"text": ..., "tooltip": ..., "class": ...}.
# Empty text hides the indicator. "class": "active" drives the QML's
# recording-red text color — mirrors bin/capture-screenrecording's own
# screenrecording_active() check (pgrep -f "^gpu-screen-recorder").

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  echo '{"text": "󰑊", "tooltip": "Recording screen", "class": "active"}'
else
  echo '{"text": "", "tooltip": ""}'
fi
