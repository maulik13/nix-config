#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

space_props=(
  icon.font.size=25
  icon.y_offset=0
  icon.padding_left=4
  label.drawing=off
  background.height=34
  background.corner_radius=12
  script="$PLUGIN_DIR/space_app.sh"
)

if [ $SHOW_SPACE_APPS -eq 1 ]; then
  space_props+=(
    label.drawing=on
    icon.padding_left=8
    background.corner_radius=24
    label.font="sketchybar-app-font:Regular:18.0"
  )
fi

add_separator space.start left 8

# Label is on the right (which are app icons hence app-font)
for sid in "${SPACE_SIDS[@]}"; do
  sketchybar --add space space.$sid left \
    --set space.$sid space=$sid \
    icon="${SPACE_ICONS[$sid - 1]}" \
    icon.width=40 icon.align="center" \
    ${space_props[@]} \
    --subscribe space.$sid mouse.clicked
done

add_separator space.end left 8

add_group_bg_light grp_spaces '/space\..*/'
