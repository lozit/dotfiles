#!/bin/bash
# RAM utilisée = 100 - pourcentage libre selon memory_pressure
FREE="$(memory_pressure -Q 2>/dev/null | awk -F': ' '/free percentage/ {gsub("%","",$2); print $2}')"
[ -z "$FREE" ] && exit 0
USED=$((100 - FREE))

COLOR=0xffe6e6e6
[ "$USED" -ge 85 ] && COLOR=0xffff6b6b

sketchybar --set "$NAME" label="$(printf '%3d%%' "$USED")" label.color=$COLOR
