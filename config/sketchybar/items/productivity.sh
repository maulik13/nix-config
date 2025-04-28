#!/bin/bash

source "$HOME/.config/sketchybar/colors/catppuccin.sh"
source "$HOME/.config/sketchybar/common.sh"

taskwarrior=(
  update_freq=120
  icon=$ICON_TASK
  icon.color=$MAROON
  label.color=$TEXT
  padding_right=16
)

noti_slack=(
  update_freq=30
  icon.y_offset=0
  icon=$ICON_SLACK
  icon.color=$TEAL
  label.color=$TEXT
  padding_left=16
)

sketchybar --add item taskwarrior right \
  --set taskwarrior script="$PLUGIN_DIR/noti_task.sh" \
  "${taskwarrior[@]}"

sketchybar --add item slack right \
  --set slack script="$PLUGIN_DIR/noti_slack.sh" \
  "${noti_slack[@]}"

add_group_bg productivity 'taskwarrior slack'
