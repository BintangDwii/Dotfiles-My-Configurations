#!/bin/bash
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

if command -v xinput >/dev/null && xinput list --name-only | grep -Fxq "ASUE1301:00 04F3:3128 Touchpad"; then
    xinput set-prop "ASUE1301:00 04F3:3128 Touchpad" "libinput Tapping Enabled" 1
fi

xmodmap -e "add mod3 = Scroll_Lock"

if command -v unclutter >/dev/null; then
    unclutter -idle 1 -root
fi
