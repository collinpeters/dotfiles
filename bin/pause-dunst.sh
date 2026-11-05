#!/bin/bash

# --- Configuration ---
DEFAULT_MINUTES=5 # Default time if no argument is provided

# Determine the duration: the first argument ($1) in minutes, or the default if omitted
DISPLAY_MINUTES=${1:-$DEFAULT_MINUTES}
if [[ ! "$DISPLAY_MINUTES" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Usage: $(basename "$0") [minutes]  (got '$1'; expected a number like 5 or 1.5)" >&2
    exit 2
fi
# Calculate seconds from minutes
DURATION_SECONDS=$(awk "BEGIN {print $DISPLAY_MINUTES * 60}")


# --- Trap and Cleanup Function ---
# Define the function to run when the script exits or is interrupted
cleanup() {
    [[ -n "$SLEEP_PID" ]] && kill "$SLEEP_PID" 2>/dev/null
    echo ""
    if [[ "$WAS_PAUSED" == "true" ]]; then
        echo "Script terminated or finished. Dunst was already paused before; leaving it paused."
        return
    fi
    echo "Script terminated or finished. Resuming dunst..."
    dunstctl set-paused false
    echo "Dunst resumed."
}

# Remember whether dunst was already paused, so cleanup doesn't unpause it behind your back
WAS_PAUSED=$(dunstctl is-paused)

# EXIT covers every way out; INT/TERM just exit so cleanup runs once, via EXIT
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM


# --- Main Logic ---
# Pause dunst
echo "Pausing dunst for $DISPLAY_MINUTES minutes..."
dunstctl set-paused true

# Wait for the specified duration (supports non-integers in DURATION_SECONDS due to awk calculation).
# Sleep in the background and `wait`, so a signal interrupts the wait immediately;
# bash defers traps until a foreground command finishes.
sleep "$DURATION_SECONDS" &
SLEEP_PID=$!
wait "$SLEEP_PID"

# The cleanup function (trap) will automatically run when sleep finishes or is interrupted.
