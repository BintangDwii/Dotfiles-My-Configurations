#!/usr/bin/env bash

set -euo pipefail

if ! temperature=$(timeout 2 sensors -j 2>/dev/null | jq -r '."k10temp-pci-00c3".Tctl.temp1_input // empty'); then
    printf '%%{F#627E97}TEMP n/a%%{F-}'
    exit 0
fi

if [ -z "$temperature" ]; then
    printf '%%{F#627E97}TEMP n/a%%{F-}'
    exit 0
fi

if (( ${temperature%.*} >= 90 )); then
    color='#E52E2E'
elif (( ${temperature%.*} >= 80 )); then
    color='#F4C95D'
else
    color='#47FF9C'
fi

printf '%%{F%s}TEMP %.0fC%%{F-}' "$color" "$temperature"
