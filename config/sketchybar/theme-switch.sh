#!/bin/bash

# SketchyBar Theme Switcher
# Usage: ./theme-switch.sh [theme_name]
# Available themes: catppuccin, rosepine

THEME=${1:-catppuccin}
CONFIG_DIR="$HOME/.config/sketchybar"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/sketchybar"
STATE_FILE="$STATE_DIR/theme"

# Validate theme exists
if [[ ! -f "$CONFIG_DIR/colors/$THEME.sh" ]]; then
    echo "Error: Theme '$THEME' not found in $CONFIG_DIR/colors/"
    echo "Available themes:"
    ls "$CONFIG_DIR/colors/"*.sh 2>/dev/null | xargs -n1 basename | sed 's/\.sh$//' | sed 's/^/  /'
    exit 1
fi

echo "Switching to $THEME theme..."

# Record the selection outside the nix store
#
# This used to sed the `source` line in sketchybarrc and common.sh, which could
# never work: both are read-only symlinks into /nix/store (the derivation in
# programs/sketchybar.nix ends with `chmod -R a-w`), so sed exits 1 on each and
# the bar kept whatever palette it was built with. Both files now source
# theme.sh, which reads the name written here.
if [[ ! -r "$CONFIG_DIR/theme.sh" ]]; then
    echo "Warning: $CONFIG_DIR/theme.sh is missing - run 'task update-osx' first."
    echo "         Writing the state file anyway; it takes effect after rebuild."
fi

if ! mkdir -p "$STATE_DIR"; then
    echo "Error: could not create $STATE_DIR" >&2
    exit 1
fi

if ! printf '%s\n' "$THEME" > "$STATE_FILE"; then
    echo "Error: could not write $STATE_FILE" >&2
    exit 1
fi
echo "Recorded '$THEME' in $STATE_FILE"

# Reload sketchybar
if command -v sketchybar >/dev/null 2>&1; then
    sketchybar --reload
    echo "SketchyBar reloaded with $THEME theme"
else
    echo "Warning: sketchybar command not found. Please reload manually."
fi

# Update Alfred theme
#
# Alfred imports themes into its own preferences bundle and gives each one a
# generated UUID, so there is no path to point at the way there is for the
# sketchybar color files - it is switched by name over AppleScript. The names
# come from the vendored themes in config/alfred/themes; run
# config/alfred/import-themes.sh if Alfred does not know one yet. To use a
# different Catppuccin style, swap Modern for Default or Macos below.
case "$THEME" in
    catppuccin) ALFRED_THEME="Catppuccin Modern - Macchiato" ;;
    rosepine)   ALFRED_THEME="Rosé Pine Moon" ;;
    *)          ALFRED_THEME="" ;;
esac

# `set theme` reports success even for a theme Alfred does not have, so the
# exit code proves nothing - check the imported list instead.
alfred_has_theme() {
    local dir="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/themes"
    [[ -d "$dir" ]] || return 1
    find "$dir" -name theme.json -exec jq -r '.alfredtheme.name' {} \; 2>/dev/null |
        grep -qxF "$1"
}

if [[ -z "$ALFRED_THEME" ]]; then
    echo "Warning: no Alfred theme mapped for '$THEME', leaving Alfred unchanged"
elif ! pgrep -xq "Alfred"; then
    echo "Warning: Alfred is not running, skipping its theme"
elif ! command -v jq >/dev/null 2>&1; then
    echo "Warning: jq not found, cannot verify Alfred themes. Switching blind."
    osascript -e "tell application \"Alfred 5\" to set theme \"$ALFRED_THEME\"" 2>/dev/null
elif ! alfred_has_theme "$ALFRED_THEME"; then
    echo "Warning: Alfred has no theme '$ALFRED_THEME'. Run config/alfred/import-themes.sh"
else
    osascript -e "tell application \"Alfred 5\" to set theme \"$ALFRED_THEME\"" 2>/dev/null
    echo "Alfred switched to $ALFRED_THEME"
fi

echo "Theme switch to '$THEME' completed!"