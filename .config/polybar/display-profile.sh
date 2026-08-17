#!/usr/bin/env bash

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/i3/display-profile"

if [ -r "$state_file" ]; then
    read -r profile < "$state_file"
    case "$profile" in
        performance)
            printf 'PERF 240/144'
            exit 0
            ;;
        battery)
            printf 'BATT 60/120'
            exit 0
            ;;
    esac
fi

printf 'DISP'
