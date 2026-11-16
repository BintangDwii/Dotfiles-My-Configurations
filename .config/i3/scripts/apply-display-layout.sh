#!/usr/bin/env bash

set -euo pipefail

internal_output="$(xrandr --query | awk '/ connected/ && $1 ~ /^eDP/ {print $1; exit}')"
internal_mode="1366x768"
internal_rate="${INTERNAL_RATE:-60}"

if [ -z "$internal_output" ]; then
    exit 0
fi

external_output="$(xrandr --query | awk -v internal="$internal_output" '/ connected/ && $1 != internal {print $1; exit}')"

if [ -z "$external_output" ]; then
    xrandr --output "$internal_output" --mode "$internal_mode" --rate "$internal_rate" --pos 0x0 --primary
    exit 0
fi

xrandr --output "$external_output" --auto --primary --pos 0x0

external_geometry="$(xrandr --query | awk -v output="$external_output" '$1 == output && $2 == "connected" {for (i = 3; i <= NF; i++) if ($i ~ /^[0-9]+x[0-9]+/) {print $i; exit}}')"
external_width="${external_geometry%%x*}"
external_height="${external_geometry#*x}"
external_height="${external_height%%+*}"

internal_height="${internal_mode#*x}"
internal_x="$external_width"
internal_y=$((external_height - internal_height))
if [ "$internal_y" -lt 0 ]; then
    internal_y=0
fi

xrandr --output "$internal_output" --mode "$internal_mode" --rate "$internal_rate" --pos "${internal_x}x${internal_y}"
