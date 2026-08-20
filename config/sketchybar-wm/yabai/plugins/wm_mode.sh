#!/bin/bash
source "$HOME/.config/sketchybar/common.sh"

space_number=$(yabai -m query --spaces --space | jq -r .index)
wm_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$wm_mode" in
bsp)
  set_wm_mode_tiled
  ;;
stack)
  set_wm_mode_stacked
  ;;
float)
  set_wm_mode_floating
  ;;
esac
