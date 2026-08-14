#!/bin/bash

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# Sourced rather than executed: run directly, icon_map.sh appends a trailing
# space to every icon, which sketchybar renders as padding. Sourcing skips that
# footer and hands us the bare glyph in $icon_result.
source "$CONFIG_DIR/plugins/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  __icon_map "$INFO"
  sketchybar --set $NAME label="$INFO" icon="$icon_result"
fi
