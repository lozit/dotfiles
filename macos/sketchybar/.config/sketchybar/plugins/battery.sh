#!/bin/bash
BATT="$(pmset -g batt)"
PERCENT="$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
[ -z "$PERCENT" ] && exit 0

COLOR=0xffe6e6e6
[ "$PERCENT" -le 20 ] && COLOR=0xffff6b6b

if echo "$BATT" | grep -q 'AC Power'; then
  ICON="BAT+"
else
  ICON="BAT"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENT}%" label.color=$COLOR
