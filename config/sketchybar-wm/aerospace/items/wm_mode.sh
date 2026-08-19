#!/bin/bash

sketchybar --add item wm_mode q \
  --set wm_mode update_freq=3 \
  label.font="VictorMono Nerd Font:Regular:18.0" \
  label.color=$PEACH \
  label.drawing=on \
  icon.drawing=off \
  wm_mode script="$CONFIG_DIR/plugins/wm_mode.sh" \
  wm_mode click_script="$CONFIG_DIR/plugins/wm_mode_click.sh" \
  --subscribe wm_mode aerospace_workspace_change
