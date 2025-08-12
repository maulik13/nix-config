#!/bin/bash

sketchybar --add item timer right \
  --set timer label="No timer" \
  icon=􀐱 \
  icon.color=$PEACH \
  icon.padding_right=6 \
  background.drawing=off \
  script="$PLUGIN_DIR/timer.sh" \
  popup.background.color=$SURFACE1 \
  popup.background.border_width=1 \
  popup.background.corner_radius=5 \
  popup.background.border_color=$MAUVE \
  popup.background.shadow.color=$SHADOW_COLOR \
  popup.background.shadow.angle=270 \
  --subscribe timer mouse.clicked mouse.entered mouse.exited mouse.exited.global

for timer in "5" "10" "25"; do
  sketchybar --add item "timer.${timer}" popup.timer \
    --set "timer.${timer}" label="${timer} Minutes" \
    padding_right=8 \
    click_script="$PLUGIN_DIR/timer.sh $((timer * 60)); sketchybar -m --set timer popup.drawing=off"
done
