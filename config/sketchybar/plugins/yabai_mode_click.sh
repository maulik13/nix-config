#!/bin/bash
source "$HOME/.config/sketchybar/common.sh"

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$yabai_mode" in
bsp)
  yabai -m space --layout stack && set_yabai_mode_bsp
  ;;
stack)
  yabai -m space --layout float && set_yabai_mode_stack
  ;;
float)
  yabai -m space --layout bsp && set_yabai_mode_float
  ;;
esac
