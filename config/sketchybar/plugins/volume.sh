#!/bin/bash

source "$HOME/.config/sketchybar/colors/catppuccin.sh"
source "$HOME/.config/sketchybar/common.sh"

function update_status() {
  # The volume_change event supplies a $INFO variable in which the current volume
  # percentage is passed to the script.

  VOLUME="$INFO"
  ICON_WIDTH=36

  case "$VOLUME" in
  [8-9][0-9] | 100)
    ICON=${ICONS_VOLUME[3]}
    COLOR=$RED
    ICON_WIDTH=36
    ;;
  [6-7][0-9])
    ICON=${ICONS_VOLUME[3]}
    COLOR=$PEACH
    ICON_WIDTH=36
    ;;
  [3-5][0-9])
    ICON=${ICONS_VOLUME[2]}
    COLOR=$MAUVE
    ICON_WIDTH=32
    ;;
  [1-9] | [1-2][0-9])
    ICON=${ICONS_VOLUME[1]}
    COLOR=$MAUVE
    ICON_WIDTH=28
    ;;
  *)
    ICON=${ICONS_VOLUME[0]}
    COLOR=$SUBTEXT0
    ICON_WIDTH=24
    ;;
  esac

  sketchybar --set volume_icon icon=$ICON \
    icon.color="$COLOR" \
    icon.width=$ICON_WIDTH

  sketchybar --set $NAME slider.percentage=$VOLUME \
    --animate tanh 30 --set $NAME slider.width=$WIDTH
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

case "$SENDER" in
"volume_change")
  update_status
  ;;
"mouse.clicked")
  mouse_clicked
  ;;
esac
