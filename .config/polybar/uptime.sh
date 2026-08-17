#!/usr/bin/env bash

output=$(uptime -p)
printf '%%{F#47FF9C}UP%%{F-}%s\n' "${output#up}"
