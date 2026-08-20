#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# Workspaces are declared in darwin/aerospace.nix and always exist, so there is
# nothing to create or destroy from the bar. What remains is the separator that
# used to carry that click.
sketchybar --add item space_separator left \
  --set space_separator \
  icon=$ICON_SPACE_SEP \
  icon.color=$WHITE_ALPHA2 \
  label.drawing=off \
  background.drawing=off
