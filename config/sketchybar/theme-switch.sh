#!/bin/bash

# SketchyBar Theme Switcher
# Usage: ./theme-switch.sh [theme_name]
# Available themes: catppuccin, rosepine

THEME=${1:-catppuccin}
CONFIG_DIR="$HOME/.config/sketchybar"
SKETCHYBARRC="$CONFIG_DIR/sketchybarrc"
COMMON_SH="$CONFIG_DIR/common.sh"

# Validate theme exists
if [[ ! -f "$CONFIG_DIR/colors/$THEME.sh" ]]; then
    echo "Error: Theme '$THEME' not found in $CONFIG_DIR/colors/"
    echo "Available themes:"
    ls "$CONFIG_DIR/colors/"*.sh 2>/dev/null | xargs -n1 basename | sed 's/\.sh$//' | sed 's/^/  /'
    exit 1
fi

echo "Switching to $THEME theme..."

# Update sketchybarrc to source the new theme
if [[ -f "$SKETCHYBARRC" ]]; then
    sed -i '' "s|source \".*colors/.*\.sh\"|source \"$CONFIG_DIR/colors/$THEME.sh\"|" "$SKETCHYBARRC"
    echo "Updated $SKETCHYBARRC"
else
    echo "Warning: $SKETCHYBARRC not found"
fi

# Update common.sh to source the new theme
if [[ -f "$COMMON_SH" ]]; then
    sed -i '' "s|source \".*colors/.*\.sh\"|source \"$CONFIG_DIR/colors/$THEME.sh\"|" "$COMMON_SH"
    echo "Updated $COMMON_SH"
else
    echo "Warning: $COMMON_SH not found"
fi

# Reload sketchybar
if command -v sketchybar >/dev/null 2>&1; then
    sketchybar --reload
    echo "SketchyBar reloaded with $THEME theme"
else
    echo "Warning: sketchybar command not found. Please reload manually."
fi

echo "Theme switch to '$THEME' completed!"