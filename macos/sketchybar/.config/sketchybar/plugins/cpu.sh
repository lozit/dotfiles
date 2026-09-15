#!/bin/bash
# Charge CPU moyenne sur tous les cœurs logiques
CORES="$(sysctl -n hw.logicalcpu)"
LOAD="$(ps -A -o %cpu= | awk -v c="$CORES" '{s+=$1} END {v=s/c; if (v>100) v=100; printf "%d", v}')"

COLOR=0xffe6e6e6
[ "$LOAD" -ge 80 ] && COLOR=0xffff6b6b

sketchybar --set "$NAME" label="$(printf '%3d%%' "$LOAD")" label.color=$COLOR
