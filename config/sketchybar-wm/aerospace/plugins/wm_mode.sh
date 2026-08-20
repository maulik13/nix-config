#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# AeroSpace reports layouts as h_tiles / v_tiles / h_accordion / v_accordion.
# Floating is a property of a window rather than of the workspace, so check the
# focused window first and fall back to the workspace's root container.
window_layout=$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null | head -1)
root_layout=$(aerospace list-workspaces --focused --format '%{workspace-root-container-layout}' 2>/dev/null | head -1)

case "$window_layout" in
*floating*)
  set_wm_mode_floating
  ;;
*)
  case "$root_layout" in
  *accordion*) set_wm_mode_stacked ;;
  *) set_wm_mode_tiled ;;
  esac
  ;;
esac
