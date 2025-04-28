#!/bin/sh
PENDING_TASK=$(zsh -c "taskw +PENDING count")
OVERDUE_TASK=$(zsh -c "taskw +OVERDUE count")

if [[ $PENDING_TASK == 0 ]]; then
  sketchybar --set $NAME label.drawing=off \
    icon.padding_right=8
else
  if [[ $OVERDUE_TASK == 0 ]]; then
    LABEL=$PENDING_TASK
  else
    LABEL="!$OVERDUE_TASK/$PENDING_TASK"
  fi

  sketchybar --set $NAME label="${LABEL}" \
    label.drawing=on \
    icon.padding_right=4
fi
