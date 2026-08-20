#!/bin/bash
source "$HOME/.config/sketchybar/common.sh"

space_number=$(yabai -m query --spaces --space | jq -r .index)
wm_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$wm_mode" in
bsp)
  yabai -m space --layout stack && set_wm_mode_stacked
  ;;
stack)
  yabai -m space --layout float && set_wm_mode_floating
  ;;
float)
  yabai -m space --layout bsp && set_wm_mode_tiled
  ;;
esac
