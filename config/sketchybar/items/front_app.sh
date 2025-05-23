#!/bin/bash

sketchybar --add item front_app q \
  --set front_app \
  icon.color=$GREEN \
  icon.font="sketchybar-app-font:Regular:20.0" \
  label.font="VictorMono Nerd Font:SemiBold Italic:18.0" \
  label.y_offset=1 \
  label.color=$GREEN \
  padding_left=8 \
  padding_right=8 \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
