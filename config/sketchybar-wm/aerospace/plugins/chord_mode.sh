#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# Read the mode from AeroSpace rather than from the event payload. The timer tick
# carries no payload at all, and one source of truth cannot drift out of step
# with the window manager the way a cached one could.
mode=$(aerospace list-modes --current 2>/dev/null | head -1)

# Popup rows, as key<TAB>target<TAB>command. The command is what a click runs, so
# the cue list doubles as a menu - the same thing the volume and timer popups do.
# Tab-delimited because monitor names contain spaces.
rows=()
add_row() { rows+=("$1"$'\t'"$2"$'\t'"$3"); }

# Rebuilt from scratch every time, so a row can never survive into a mode that
# does not have it. One batched call keeps the popup from flickering.
args=(--remove '/chord\.row\..*/')

case "$mode" in
window)
  breadcrumb="window"
  add_row s space "aerospace mode window-space"
  add_row m monitor "aerospace mode window-monitor"
  ;;
window-space)
  breadcrumb="window ▸ space"
  # Numbered from WM_WORKSPACES, which programs/sketchybar.nix reads out of
  # AeroSpace's own persistent-workspaces - the same list the digits are bound
  # from, so the cue cannot advertise a key that does something else.
  for i in "${!WM_WORKSPACES[@]}"; do
    ws="${WM_WORKSPACES[$i]}"
    add_row "$((i + 1))" "$ws" "aerospace move-node-to-workspace $ws; aerospace mode main"
  done
  ;;
window-monitor)
  breadcrumb="window ▸ monitor"
  # Only the monitors actually attached, so an undocked laptop stops offering
  # keys that would do nothing. Commands address them by id, never by name.
  while read -r id name; do
    [ -n "$id" ] || continue
    add_row "$id" "$name" \
      "aerospace move-node-to-monitor --focus-follows-window $id; aerospace mode main"
  done < <(aerospace list-monitors --format '%{monitor-id} %{monitor-name}' 2>/dev/null)
  ;;
main | "")
  sketchybar -m "${args[@]}" --set chord_mode drawing=off popup.drawing=off >/dev/null
  exit 0
  ;;
*)
  # An undeclared mode. AeroSpace does not validate mode names, so a typo in
  # `aerospace mode ...` silently leaves every binding dead - saying so on the
  # bar beats a keyboard that has quietly stopped responding.
  sketchybar -m "${args[@]}" --set chord_mode \
    drawing=on popup.drawing=off \
    icon="$mode" icon.color="$STATUS_ERROR" \
    label="unknown mode · run: aerospace mode main" label.color="$STATUS_ERROR" >/dev/null
  exit 0
  ;;
esac

n=0
for row in "${rows[@]}"; do
  IFS=$'\t' read -r key target cmd <<<"$row"
  args+=(
    --add item "chord.row.$n" popup.chord_mode
    --set "chord.row.$n"
    icon="$key"
    icon.font="VictorMono Nerd Font:Bold:15.0"
    icon.color="$CONTEXT_WM"
    icon.padding_left=10
    icon.padding_right=10
    label="$target"
    label.font="VictorMono Nerd Font:Medium:15.0"
    label.color="$TEXT"
    label.padding_right=14
    background.drawing=off
    click_script="$cmd; sketchybar --trigger aerospace_mode_change"
  )
  n=$((n + 1))
done

# esc as the label rather than a popup row: it is the one key that matters when
# you no longer know what is armed, so it belongs where the eye already is.
#
# The popup style is re-applied here, not just once in items/chord_mode.sh,
# because a `task update-osx` swaps this plugin in immediately while the running
# bar keeps the item definition it was loaded with. Styling the popup on every
# render means the dropdown matches the timer's even against a stale item that
# has never heard of POPUP_COMMON_PROPS - the alternative is an unstyled popup
# until the next ctrl+alt+shift+m.
args+=(
  --set chord_mode
  drawing=on
  popup.drawing=on
  popup.align=center
  "${POPUP_COMMON_PROPS[@]}"
  icon="$breadcrumb"
  icon.color="$CONTEXT_WM"
  label="esc"
  label.color="$SUBITEM_COLOR"
)

sketchybar -m "${args[@]}" >/dev/null
