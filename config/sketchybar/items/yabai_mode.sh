#!/bin/bash

sketchybar -m --add item yabai_mode left \
  --set yabai_mode update_freq=3 \
  --set yabai_mode script="$CONFIG_DIR/plugins/yabai_mode.sh" \
  --set yabai_mode click_script="$CONFIG_DIR/plugins/yabai_mode_click.sh" \
  --subscribe yabai_mode space_change
