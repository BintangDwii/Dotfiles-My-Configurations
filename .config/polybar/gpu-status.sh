#!/usr/bin/env bash

set -euo pipefail

if ! data=$(timeout 2 nvidia-smi --query-gpu=temperature.gpu,power.draw,utilization.gpu,memory.used --format=csv,noheader,nounits 2>/dev/null); then
    printf '%%{F#627E97}GPU off%%{F-}'
    exit 0
fi

IFS=',' read -r temperature power utilization memory <<< "$data"

if (( ${temperature//[[:space:]]/} >= 90 )); then
    color='#E52E2E'
elif (( ${temperature//[[:space:]]/} >= 80 )); then
    color='#F4C95D'
else
    color='#0FC5ED'
fi

printf '%%{F%s}GPU %.0fC %.0fW %.0f%%%s' "$color" "$temperature" "$power" "$utilization" '%{F-}'
