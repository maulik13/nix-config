#!/bin/bash

function handle_windows_change() {
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app; do
      icon_strip+="$($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<<"${apps}"
  fi

  # If space is empty remove padding between icon and label
  LABEL_GAP=3
  if [ "$icon_strip" = "" ]; then
    # negative is a hack to remove extra padding when selected
    LABEL_GAP=-1
  fi

  sketchybar --set space.$space \
    label="$icon_strip" \
    label.padding_left=$LABEL_GAP \
    icon.padding_right=$LABEL_GAP
}

case "$SENDER" in
"space_windows_change")
  handle_windows_change
  ;;
*)
  update
  ;;
esac
