#!/usr/bin/env bash

set -euo pipefail

script_directory="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
layout_script="$script_directory/apply-display-layout.sh"
state_directory="${XDG_STATE_HOME:-$HOME/.local/state}/i3"
state_file="$state_directory/display-profile"

apply_profile() {
    local profile="$1"
    local internal_rate

    case "$profile" in
        performance|battery)
            internal_rate="60"
            ;;
        *)
            printf 'Usage: %s {performance|battery}\n' "$0" >&2
            exit 2
            ;;
    esac

    INTERNAL_RATE="$internal_rate" "$layout_script"

    mkdir -p "$state_directory"
    printf '%s\n' "$profile" > "$state_file"
}

apply_profile "${1:-performance}"
