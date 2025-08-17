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

SPACE_COLORS=($NAV_ACCENT $STATUS_SUCCESS $STATUS_ERROR $STATUS_WARNING $NAV_PRIMARY $INFO_ACCENT $STATUS_WARNING $INFO_ACCENT $TEXT)
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
  local border="${3:-$GROUP_BORDER}"
  local bg="${4:-$GROUP_BG}"
  sketchybar --add bracket $group_name $items \
    --set $group_name \
    background.corner_radius=8 \
    background.height=36 \
    background.color=$bg \
    background.border_width=1 \
    background.border_color=$border
}

function add_group_bg_light() {
  add_group_bg "$1" "$2" $GROUP_LIGHT_BORDER $GROUP_LIGHT_BG
}

POPUP_COMMON_PROPS=(
  popup.background.color=$POPUP_BG_COLOR
  popup.background.border_width=2
  popup.background.corner_radius=5
  popup.background.border_color=$POPUP_BORDER_COLOR
  popup.background.shadow.color=$SHADOW_COLOR
  popup.background.shadow.angle=270
)

function set_yabai_mode_bsp() {
  sketchybar -m --set yabai_mode label="" label.color=$CONTEXT_WM_BSP
}
function set_yabai_mode_stack() {
  sketchybar -m --set yabai_mode label="" label.color=$CONTEXT_WM_STACK
}
function set_yabai_mode_float() {
  sketchybar -m --set yabai_mode label="" label.color=$CONTEXT_WM_FLOAT
}
