#!/bin/bash

sketchybar --add item yabai_mode q \
  --set yabai_mode update_freq=3 \
  label.font="VictorMono Nerd Font:Regular:18.0" \
  label.color=$PEACH \
  label.drawing=on \
  icon.drawing=off \
  yabai_mode script="$CONFIG_DIR/plugins/yabai_mode.sh" \
  yabai_mode click_script="$CONFIG_DIR/plugins/yabai_mode_click.sh" \
  --subscribe yabai_mode space_change
