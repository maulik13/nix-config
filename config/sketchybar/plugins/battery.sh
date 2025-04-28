#!/bin/bash

source "$HOME/.config/sketchybar/colors/catppuccin.sh"
source "$HOME/.config/sketchybar/common.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"
ICON_IND=0

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
100)
  ICON_IND=10
  COLOR=$GREEN
  ;;
9[0-9])
  ICON_IND=9
  COLOR=$GREEN
  ;;
8[0-9])
  ICON_IND=8
  COLOR=$TEAL
  ;;
7[0-9])
  ICON_IND=7
  COLOR=$TEAL
  ;;
6[0-9])
  ICON_IND=6
  COLOR=$SAPPHIRE
  ;;
5[0-9])
  ICON_IND=5
  COLOR=$SAPPHIRE
  ;;
4[0-9])
  ICON_IND=4
  COLOR=$SAPPHIRE
  ;;
3[0-9])
  ICON_IND=3
  COLOR=$YELLOW
  ;;
2[0-9])
  ICON_IND=2
  COLOR=$YELLOW
  ;;
1[0-9])
  ICON_IND=1
  COLOR=$RED
  ;;
*)
  ICON_IND=0
  COLOR=$RED
  ;;
esac

ICON=${ICONS_BATTERY[$ICON_IND]}

if [[ "$CHARGING" != "" ]]; then
  ICON=${ICONS_BATTERY_CHARGING[$ICON_IND]}
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=$COLOR
