#!/bin/bash
BIN="$CONFIG_DIR/helpers/next_event"
[ -x "$BIN" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

# Look ahead until midnight at the end of tomorrow: later events would show
# a bare time (the helper only prefixes "demain"), easily mistaken for today
NOW=$(date +%s)
END=$(date -v+2d -v0H -v0M -v0S +%s)
HOURS=$(awk "BEGIN { print ($END - $NOW) / 3600 }")

OUT="$("$BIN" "$HOURS")"
if [ -z "$OUT" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

LABEL="${OUT%$'\t'*}"
URGENT="${OUT##*$'\t'}"
COLOR=0xffe6e6e6
[ "$URGENT" = "1" ] && COLOR=0xffff6b6b

sketchybar --set "$NAME" drawing=on label="$LABEL" label.color=$COLOR
