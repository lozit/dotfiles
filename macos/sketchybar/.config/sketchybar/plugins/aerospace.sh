#!/bin/bash
# $1 = identifiant du workspace porté par l'item
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$1" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" icon.color=0xffffffff icon.font="SF Mono:Heavy:13.0"
else
  sketchybar --set "$NAME" icon.color=0x66e6e6e6 icon.font="SF Mono:Bold:12.0"
fi
