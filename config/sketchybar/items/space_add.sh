#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

seperator_props=(
  icon=$ICON_SPACE_SEP
  icon.color=$WHITE_ALPHA2
  label.drawing=off
  background.drawing=off
)

if [ $SHOW_SPACE_APPS -eq 1 ]; then
  seperator_props+=(
    script="$PLUGIN_DIR/space_windows.sh"
  )
fi

sketchybar --add item space_separator left \
  --set space_separator ${seperator_props[@]} \
  click_script='yabai -m space --create && sketchybar --trigger space_change' \
  --subscribe space_separator space_windows_change
