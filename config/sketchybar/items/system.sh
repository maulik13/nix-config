#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  padding_left=0
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$WHITE_ALPHA2
  slider.knob=􀀁
  slider.knob.drawing=on
)

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  icon=$VOLUME_100
  label.drawing=off
  icon.color=$GREY
  popup.background.color=$BASE
  popup.background.corner_radius=5
  padding_left=10
)

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.y_offset=0
  label.align=right
  update_freq=120
  padding_left=0
  padding_right=12
)

cpu=(
  script="$PLUGIN_DIR/cpu.sh"
  update_freq=60
  padding_left=0
  padding_right=0
  icon=$ICON_CPU
  icon.color=$YELLOW
)

sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery system_woke power_source_change \
  \
  --add item cpu right \
  --set cpu "${cpu[@]}" \
  \
  --add slider volume right \
  --set volume "${volume_slider[@]}" \
  --subscribe volume volume_change \
  mouse.clicked \
  \
  --add item volume_icon right \
  --set volume_icon "${volume_icon[@]}"

add_group_bg system 'volume_icon volume battery cpu'
