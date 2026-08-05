#!/usr/bin/env bash

set -euo pipefail

internal_output="eDP"
external_output="HDMI-1-0"
state_directory="${XDG_STATE_HOME:-$HOME/.local/state}/i3"
state_file="$state_directory/display-profile"

output_is_connected() {
    xrandr --query | rg -q "^$1 connected"
}

apply_profile() {
    local profile="$1"
    local internal_rate
    local external_rate

    case "$profile" in
        performance)
            internal_rate="240"
            external_rate="144"
            ;;
        battery)
            internal_rate="60"
            external_rate="119.88"
            ;;
        *)
            printf 'Usage: %s {performance|battery}\n' "$0" >&2
            exit 2
            ;;
    esac

    xrandr --output "$internal_output" --mode 2560x1600 --rate "$internal_rate" --primary

    if output_is_connected "$external_output"; then
        xrandr --output "$external_output" --mode 3840x2160 --rate "$external_rate" --right-of "$internal_output"
    fi

    mkdir -p "$state_directory"
    printf '%s\n' "$profile" > "$state_file"
}

apply_profile "${1:-performance}"
