#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

taskwarrior=(
  update_freq=120
  icon=$ICON_TASK
  icon.color=$MAROON
  label.color=$TEXT
)

noti_slack=(
  update_freq=30
  icon.y_offset=0
  icon=$ICON_SLACK
  icon.color=$TEAL
  label.color=$TEXT
)

# sketchybar --add item taskwarrior right \
#   --set taskwarrior script="$PLUGIN_DIR/noti_task.sh" \
#   "${taskwarrior[@]}"

add_separator sep.prod.r1 right 8
source $ITEM_DIR/timer.sh

sketchybar --add item slack right \
  --set slack script="$PLUGIN_DIR/noti_slack.sh" \
  "${noti_slack[@]}"

add_separator sep.prod.r2 right 8
add_group_bg productivity 'sep.prod.r1 timer slack sep.prod.r2'
