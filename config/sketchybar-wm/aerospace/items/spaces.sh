#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# AeroSpace workspaces are not macOS Spaces, so sketchybar's native `space`
# component cannot follow them - it tracks Mission Control, which AeroSpace
# never switches. These are plain items instead, refreshed by the
# aerospace_workspace_change event that AeroSpace fires on every switch
# (see exec-on-workspace-change in darwin/aerospace.nix).
sketchybar --add event aerospace_workspace_change

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

# The item name carries the workspace; plugins recover it with ${NAME#space.}
for i in "${!WM_WORKSPACES[@]}"; do
  ws="${WM_WORKSPACES[$i]}"
  # display= keeps each workspace on the bar of the monitor it belongs to, the
  # way the native `space` component used to. space_app.sh re-reads the real
  # assignment from AeroSpace on every update; this is just the first paint.
  sketchybar --add item space.$ws left \
    --set space.$ws \
    display="${WM_WORKSPACE_DISPLAYS[$i]:-all}" \
    icon="${SPACE_ICONS[$i]}" \
    icon.width=40 icon.align="center" \
    ${space_props[@]} \
    --subscribe space.$ws aerospace_workspace_change mouse.clicked
done

add_separator space.end left 8

add_group_bg_light grp_spaces '/space\..*/'
