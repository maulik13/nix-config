#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# Same cycle the yabai bar had - tiled, stacked, floating - mapped onto
# AeroSpace: tiles, accordion, floating.
window_layout=$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null | head -1)
root_layout=$(aerospace list-workspaces --focused --format '%{workspace-root-container-layout}' 2>/dev/null | head -1)

case "$window_layout" in
*floating*)
  aerospace layout tiling && set_wm_mode_tiled
  ;;
*)
  case "$root_layout" in
  *accordion*) aerospace layout floating && set_wm_mode_floating ;;
  *) aerospace layout accordion && set_wm_mode_stacked ;;
  esac
  ;;
esac
