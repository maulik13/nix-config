#!/bin/bash

# One instance per workspace item. Unlike sketchybar's native `space` component
# there is no $SELECTED here, so focus is resolved from the trigger payload -
# AeroSpace passes FOCUSED with aerospace_workspace_change - falling back to
# asking AeroSpace directly on the first draw or a manual --trigger.

source "$HOME/.config/sketchybar/common.sh"

WORKSPACE="${NAME#space.}"

CUR_SPACE_COLOR=$SPACE_NORMAL

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
  background.color=$SPACE_ACTIVE
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

set_app_icons() {
  # Sourced rather than executed per app: icon_map.sh appends a trailing space
  # to every icon when run directly, which would space out the packed strip.
  source "$CONFIG_DIR/plugins/icon_map.sh"

  local icon_strip="" app
  while read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    icon_strip+="$icon_result"
  done < <(aerospace list-windows --workspace "$WORKSPACE" --format '%{app-name}' 2>/dev/null | sort -u)

  # Negative gap is a hack to drop the extra padding when the item is selected
  local label_gap=3
  [ -z "$icon_strip" ] && label_gap=-1

  sketchybar --set $NAME \
    label="$icon_strip" \
    label.padding_left=$label_gap \
    icon.padding_right=$label_gap
}

update() {
  # Ask AeroSpace rather than trusting the trigger's FOCUSED payload. With two
  # monitors one workspace is visible per monitor and only one of them is
  # focused, so keying off focus alone would highlight nothing on the other
  # screen. 'visible' is what the native space component's $SELECTED meant.
  local visible display
  IFS='|' read -r visible display <<<"$(
    aerospace list-workspaces --all \
      --format '%{workspace}|%{workspace-is-visible}|%{monitor-appkit-nsscreen-screens-id}' 2>/dev/null |
      awk -F'|' -v w="$WORKSPACE" '$1 == w { print $2 "|" $3 }'
  )"

  # Follow the workspace if AeroSpace moved it to another monitor, e.g. after a
  # display was unplugged and everything fell back to one screen.
  [ -n "$display" ] && sketchybar --set $NAME display="$display"

  if [ "$visible" = "true" ]; then
    if [ $SHOW_SPACE_APPS -eq 1 ]; then
      sketchybar --set $NAME ${selected_props[@]} ${selected_with_apps_props[@]}
    else
      sketchybar --set $NAME ${selected_props[@]} ${selected_no_apps_props[@]}
    fi
  else
    sketchybar --set $NAME ${unselected_props[@]}
  fi

  # AeroSpace has no window-closed event, so the strip is only as fresh as the
  # last workspace change or the item's own update tick.
  [ $SHOW_SPACE_APPS -eq 1 ] && set_app_icons
}

mouse_clicked() {
  aerospace workspace "$WORKSPACE"
}

case "$SENDER" in
"mouse.clicked")
  mouse_clicked
  ;;
*)
  update
  ;;
esac
