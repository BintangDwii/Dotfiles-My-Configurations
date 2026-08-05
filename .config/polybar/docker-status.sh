#!/usr/bin/env bash

set -euo pipefail

if ! containers=$(timeout 2 docker ps -q 2>/dev/null); then
    printf '%%{F#627E97}DOCKER off%%{F-}'
    exit 0
fi

if [ -z "$containers" ]; then
    printf '%%{F#627E97}DOCKER 0%%{F-}'
    exit 0
fi

count=$(printf '%s\n' "$containers" | wc -l)
printf '%%{F#47FF9C}DOCKER %s%%{F-}' "$count"
