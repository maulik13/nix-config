#!/usr/bin/env bash

YABAI_CONFIG_DIR="${YABAI_CONFIG_DIR:-$HOME/.config/yabai}"
YABAI_LOG_DIR="${YABAI_LOG_DIR:-$HOME/.local/state/yabai}"
YABAI_LOG="$YABAI_LOG_DIR/load.log"

# load() runs from a skhd hotkey and from yabai signals, where stdout goes
# nowhere - so the outcome is reported by notification, with the detail in
# $YABAI_LOG.
notify() {
  /usr/bin/env osascript -e "display notification \"$1\" with title \"yabai\"" >/dev/null 2>&1
}

load() {
  local rc=0

  mkdir -p "$YABAI_LOG_DIR"
  notify "Reloading config..."

  {
    echo "===== load: $(date '+%Y-%m-%d %H:%M:%S') ====="
    source "$YABAI_CONFIG_DIR/spaces.sh" || rc=1
    source "$YABAI_CONFIG_DIR/rules.sh" || rc=1
    yabai -m rule --apply
    sketchybar --reload
    echo "===== finished with rc=$rc ====="
  } >"$YABAI_LOG" 2>&1

  if [ "$rc" -eq 0 ]; then
    notify "Config reloaded"
  else
    notify "Reloaded with warnings - see $YABAI_LOG"
  fi

  return "$rc"
}

sketchybar_force_restart() {
  notify "Force restarting sketchybar"
  pkill -9 sketchybar
}
