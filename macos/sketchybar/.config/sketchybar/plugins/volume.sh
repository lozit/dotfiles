#!/bin/bash
# $INFO contient le volume (0-100) lors de l'événement volume_change
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)')"
fi

MUTED="$(osascript -e 'output muted of (get volume settings)')"
if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
  sketchybar --set "$NAME" label="mute" label.color=0x99e6e6e6
else
  sketchybar --set "$NAME" label="${VOLUME}%" label.color=0xffe6e6e6
fi
