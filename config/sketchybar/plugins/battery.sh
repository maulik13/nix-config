#!/bin/bash

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
  COLOR=$GAUGE_FULL
  ;;
9[0-9])
  ICON_IND=9
  COLOR=$GAUGE_FULL
  ;;
8[0-9])
  ICON_IND=8
  COLOR=$GAUGE_HIGH
  ;;
7[0-9])
  ICON_IND=7
  COLOR=$GAUGE_HIGH
  ;;
6[0-9])
  ICON_IND=6
  COLOR=$GAUGE_MID
  ;;
5[0-9])
  ICON_IND=5
  COLOR=$GAUGE_MID
  ;;
4[0-9])
  ICON_IND=4
  COLOR=$GAUGE_MID
  ;;
3[0-9])
  ICON_IND=3
  COLOR=$GAUGE_LOW
  ;;
2[0-9])
  ICON_IND=2
  COLOR=$GAUGE_LOW
  ;;
1[0-9])
  ICON_IND=1
  COLOR=$GAUGE_CRITICAL
  ;;
*)
  ICON_IND=0
  COLOR=$GAUGE_CRITICAL
  ;;
esac

ICON=${ICONS_BATTERY[$ICON_IND]}

if [[ "$CHARGING" != "" ]]; then
  ICON=${ICONS_BATTERY_CHARGING[$ICON_IND]}
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=$COLOR
