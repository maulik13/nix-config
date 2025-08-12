#!/bin/bash

sketchybar --add item yabai_mode q \
  --set yabai_mode update_freq=3 \
  label.font="VictorMono Nerd Font:Regular:18.0" \
  label.color=$PEACH \
  label.drawing=on \
  icon.drawing=off \
  yabai_mode script="$CONFIG_DIR/plugins/yabai_mode.sh" \
  yabai_mode click_script="$CONFIG_DIR/plugins/yabai_mode_click.sh" \
  --subscribe yabai_mode space_change
# sketchybar --add item yabai_mode left \
#   --set yabai_mode \
#   --set label.font="VictorMono Nerd Font:Bold:18.0" \
#   --set label = "XXX" \
#   icon = "p"
# yabai_mode script="$CONFIG_DIR/plugins/yabai_mode.sh" \
# yabai_mode click_script="$CONFIG_DIR/plugins/yabai_mode_click.sh"
# --subscribe yabai_mode space_change # --set yabai_mode update_freq=3 \

# source "$HOME/.config/sketchybar/colors/catppuccin.sh"
# source "$HOME/.config/sketchybar/common.sh"
#
# seperator_props=(
#   icon.color=$WHITE_ALPHA2
#   font.color=$WHITE_ALPHA2
#   label='xxx'
#   label.drawing=on
#   background.drawing=off
# )
#
# sketchybar --add item yabai_mode left \
#   --set yabai_mode ${seperator_props[@]} \
#   click_script='yabai -m space --create && sketchybar --trigger space_change' \
#   --subscribe space_separator space_windows_change
