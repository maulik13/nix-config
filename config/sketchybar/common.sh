#!/bin/bash

source "$HOME/.config/sketchybar/colors/catppuccin.sh"
source "$HOME/.config/sketchybar/utils.sh"

ICONS_VOLUME=(􀊣 􀊥 􀊧 􀊩)
ICON_CPU=􀫥
ICON_TASK=􀺿
ICON_SLACK=󰒱
ICON_SPACE_SEP=􀏲
ICONS_BATTERY=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
ICONS_BATTERY_CHARGING=(󰢟 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)

SHOW_SPACE_APPS=0

SPACE_COLORS=($BLUE $GREEN $RED $PEACH $MAGENTA $SAPPHIRE $YELLOW $SKY $WHITE)
SPACE_ICONS=(󰲠 󰲢 󰲤 󰲦 󰲨 󰲪 󰲬 󰲮 󰲰)
SPACE_SIDS=(1 2 3 4 5 6 7 8 9)

function add_separator() {
  local name=$1
  local place=$2
  local gap="${3:-12}"
  sketchybar --add item $name $place \
    --set $name width=$gap \
    padding_left=0 padding_right=0 \
    background.drawing=off \
    icon.drawing=off \
    label.drawing=off
}

function add_group_outline() {
  local group_name=$1
  local items=$2
  local color=$3
  sketchybar --add bracket $group_name $items \
    --set $group_name \
    background.corner_radius=12 \
    background.height=36 \
    background.border_width=2 \
    background.border_color=$color
}

function add_group_bg() {
  local group_name=$1
  local items=$2
  local default_bg=$CRUST_ALPHA1
  local color="${3:-$default_bg}"
  sketchybar --add bracket $group_name $items \
    --set $group_name \
    background.corner_radius=12 \
    background.height=36 \
    background.color=$color
}
