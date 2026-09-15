#!/bin/bash
# Débit montant / descendant de l'interface par défaut
IFACE="$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')"
if [ -z "$IFACE" ]; then
  sketchybar --set "$NAME" label="offline" label.color=0x99e6e6e6
  exit 0
fi

read -r RX TX <<< "$(netstat -ibn -I "$IFACE" | awk 'NR==2 {print $7, $10}')"
NOW="$(date +%s)"
STATE="/tmp/sketchybar_net_$IFACE"

if [ -f "$STATE" ]; then
  read -r PRX PTX PNOW < "$STATE"
  DT=$((NOW - PNOW)); [ "$DT" -le 0 ] && DT=1
  DOWN=$(((RX - PRX) / DT))
  UP=$(((TX - PTX) / DT))
else
  DOWN=0; UP=0
fi
echo "$RX $TX $NOW" > "$STATE"

human() {
  local b=$1
  if [ "$b" -ge 1048576 ]; then awk -v b="$b" 'BEGIN {printf "%4.1fM", b/1048576}'
  elif [ "$b" -ge 1024 ]; then awk -v b="$b" 'BEGIN {printf "%4.0fK", b/1024}'
  else printf "%4dB" "$b"; fi
}

sketchybar --set "$NAME" label="↓$(human $DOWN) ↑$(human $UP)" label.color=0xffe6e6e6
