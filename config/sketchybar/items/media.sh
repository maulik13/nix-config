#!/bin/bash

sketchybar --add item media e \
  --set media label.color=$BLUE \
  label.max_chars=16 \
  icon.padding_left=0 \
  scroll_texts=on \
  icon=􀑪 \
  icon.color=$BLUE \
  padding_left=8 \
  padding_right=8 \
  background.drawing=off \
  script="$PLUGIN_DIR/media.sh" \
  --subscribe media media_change
