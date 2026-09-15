#!/bin/bash
BIN="$CONFIG_DIR/helpers/next_event"
[ -x "$BIN" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

OUT="$("$BIN" 12)"
if [ -z "$OUT" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

LABEL="${OUT%$'\t'*}"
URGENT="${OUT##*$'\t'}"
COLOR=0xffe6e6e6
[ "$URGENT" = "1" ] && COLOR=0xffff6b6b

sketchybar --set "$NAME" drawing=on label="$LABEL" label.color=$COLOR
