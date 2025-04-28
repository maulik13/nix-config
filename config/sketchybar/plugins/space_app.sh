#!/bin/bash

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

source "$HOME/.config/sketchybar/colors/catppuccin.sh" # Loads all defined colors
source "$HOME/.config/sketchybar/common.sh"

CUR_SPACE_COLOR=${SPACE_COLORS[$SID - 1]}

selected_with_apps_props=(
  background.height=36
  icon.padding_left=8
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=8
)

selected_no_apps_props=(
  background.height=38
  background.padding_left=4
  icon.padding_left=4
  icon.padding_right=4
  padding_left=8
  padding_right=8
)

selected_props=(
  background.color=$CUR_SPACE_COLOR
  icon.color=$BLACK_ALPHA0
  label.color=$CRUST_ALPHA0
  icon.font.size=28
)

unselected_props=(
  background.color=$TRANSPARENT
  icon.color=$CUR_SPACE_COLOR
  label.color=$SUBITEM_COLOR
  background.height=36
  icon.font.size=24
  icon.padding_left=4
  icon.padding_right=4
  label.padding_right=4
  label.padding_right=8
  padding_left=2
  padding_right=2
)

update() {
  if [ $SELECTED = true ]; then
    if [[ $SHOW_SPACE_APPS -eq 1 ]]; then
      sketchybar --set $NAME \
        ${selected_props[@]} \
        ${selected_with_apps_props[@]}
    else
      sketchybar --set $NAME \
        ${selected_props[@]} \
        ${selected_no_apps_props[@]}
    fi
  else
    sketchybar --set $NAME \
      ${unselected_props[@]}
  fi
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy $SID
    sketchybar --trigger windows_on_spaces --trigger space_change
  else
    yabai -m space --focus $SID 2>/dev/null
  fi
}

case "$SENDER" in
"mouse.clicked")
  mouse_clicked
  ;;
*)
  update
  ;;
esac
