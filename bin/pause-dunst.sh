#!/bin/bash

# --- Configuration ---
DEFAULT_MINUTES=5 # Default time if no argument is provided

# Determine the duration: use the first argument ($1) if it's a number, otherwise use default
if [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    # Calculate seconds from minutes argument
    DURATION_SECONDS=$(awk "BEGIN {print $1 * 60}")
    DISPLAY_MINUTES=$1
else
    DURATION_SECONDS=$(awk "BEGIN {print $DEFAULT_MINUTES * 60}")
    DISPLAY_MINUTES=$DEFAULT_MINUTES
    echo "No valid argument provided. Defaulting to $DEFAULT_MINUTES minutes."
fi


# --- Trap and Cleanup Function ---
# Define the function to run when the script exits or is interrupted
cleanup() {
    echo ""
    echo "Script terminated or finished. Resuming dunst..."
    dunstctl set-paused false
    echo "Dunst resumed."
}

# EXIT covers every way out; INT/TERM just exit so cleanup runs once, via EXIT
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM


# --- Main Logic ---
# Pause dunst
echo "Pausing dunst for $DISPLAY_MINUTES minutes..."
dunstctl set-paused true

# Wait for the specified duration (supports non-integers in DURATION_SECONDS due to awk calculation)
sleep "$DURATION_SECONDS"

# The cleanup function (trap) will automatically run when sleep finishes or is interrupted.
