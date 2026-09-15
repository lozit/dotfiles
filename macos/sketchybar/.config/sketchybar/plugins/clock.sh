#!/bin/bash
# Ex. : mar. 15 sept. 14:32
sketchybar --set "$NAME" label="$(LC_TIME=fr_FR.UTF-8 date '+%a %d %b  %H:%M')"
