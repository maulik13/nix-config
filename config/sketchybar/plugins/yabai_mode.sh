#!/bin/bash
source "$HOME/.config/sketchybar/common.sh"

space_number=$(yabai -m query --spaces --space | jq -r .index)
yabai_mode=$(yabai -m query --spaces --space | jq -r .type)

case "$yabai_mode" in
bsp)
  set_yabai_mode_bsp
  ;;
stack)
  set_yabai_mode_stack
  ;;
float)
  set_yabai_mode_float
  ;;
esac
