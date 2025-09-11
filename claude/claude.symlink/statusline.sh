#!/bin/bash

# Read JSON input from Claude Code
input=$(cat)

# Extract model display name from input
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Initialize variables
GIT_BRANCH=""
RELATIVE_DIR=""

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Get current branch
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
    
    # Get git root directory
    GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$GIT_ROOT" ]; then
        # Calculate relative path from git root
        RELATIVE_DIR=$(realpath --relative-to="$GIT_ROOT" "$CURRENT_DIR" 2>/dev/null)
        if [ "$RELATIVE_DIR" = "." ]; then
            RELATIVE_DIR="/"
        else
            RELATIVE_DIR="/$RELATIVE_DIR"
        fi
    else
        # Fallback to just current directory name
        RELATIVE_DIR="${CURRENT_DIR##*/}"
    fi
else
    # Not in git repo, just show current directory name
    RELATIVE_DIR="${CURRENT_DIR##*/}"
fi

# Output the status line
echo "[$MODEL_DISPLAY] 📁 $RELATIVE_DIR$GIT_BRANCH"