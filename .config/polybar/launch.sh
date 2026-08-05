#!/usr/bin/env bash

# Kill existing polybar instances
killall -q polybar

# Wait until they are all closed
while pgrep -u "$UID" -x polybar >/dev/null; do
  sleep 1
done

# Launch Polybar on each monitor and assign the tray to the primary display only.
while read -r monitor; do
  tray_position=none
  case "$monitor" in
    *"(primary)"*) tray_position=right ;;
  esac
  MONITOR=${monitor%%:*} TRAY_POSITION=$tray_position polybar main &
done < <(polybar --list-monitors)

wait
