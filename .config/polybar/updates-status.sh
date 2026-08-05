#!/usr/bin/env bash

set -euo pipefail

updates=$(timeout 30 pacman -Qu 2>/dev/null || true)

if [ -z "$updates" ]; then
    printf '%%{F#47FF9C}UPDATES 0%%{F-}'
    exit 0
fi

count=$(printf '%s\n' "$updates" | wc -l)
printf '%%{F#F4C95D}UPDATES %s%%{F-}' "$count"
