#!/bin/bash

# Small delay to ensure displays are ready (important on startup)
sleep 1

# Detect internal display (eDP), falling back to the primary output
INTERNAL=$(xrandr | awk '/ connected/ && $1 ~ /^eDP/ {print $1; exit}')
if [ -z "$INTERNAL" ]; then
    INTERNAL=$(xrandr | awk '/ connected primary/ {print $1; exit}')
fi

if [ -z "$INTERNAL" ]; then
    echo "No internal display detected" >&2
    exit 1
fi

# Detect external display (any connected display that is not internal)
EXTERNAL=$(xrandr | awk '/ connected/ {print $1}' | grep -vx "$INTERNAL" | head -n1)

# Decide target (external if available, otherwise internal)
if [ -n "$EXTERNAL" ]; then
    TARGET="$EXTERNAL"
else
    TARGET="$INTERNAL"
fi

# Workspace 1 always stays on the internal display
i3-msg "workspace 1; move workspace to output $INTERNAL" > /dev/null

# Workspaces 2-10 go to the external display when one is connected
for i in 2 3 4 5 6 7 8 9 10; do
    i3-msg "workspace $i; move workspace to output $TARGET" > /dev/null
done

# Focus back to the main HDMI workspace
i3-msg "workspace 2" > /dev/null
