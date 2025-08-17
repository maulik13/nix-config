#!/bin/bash

sketchybar --add item time right \
  --set time script="$PLUGIN_DIR/time.sh" \
  update_freq=5 \
  icon="􁞺" \
  icon.color=$SURFACE1 \
  label.font.style="Bold" \
  label.color=$BASE \
  icon.padding_left=4 \
  padding_left=0 \
  padding_right=4 \
  --add item date right \
  --set date script="$PLUGIN_DIR/date.sh" \
  update_freq=60 \
  icon.drawing=off \
  padding_left=8 \
  padding_right=0 \
  label.padding_right=4 \
  label.color=$BASE

add_group_bg timedate 'time date' $TRANSPARENT $WHITE_ALPHA1
