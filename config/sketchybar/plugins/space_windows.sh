#!/bin/bash

# Sourced rather than executed per app: icon_map.sh appends a trailing space to
# every icon when run directly, which would space out the packed icon strip.
# Sourcing also avoids spawning a bash process for each app on every update.
source "$CONFIG_DIR/plugins/icon_map.sh"

function handle_windows_change() {
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=""
  if [ "${apps}" != "" ]; then
    while read -r app; do
      __icon_map "$app"
      icon_strip+="$icon_result"
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
