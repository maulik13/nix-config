#!/bin/sh

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Slack")
LABEL=""

if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
    LABEL="${BASH_REMATCH[1]}"
fi

if [[ $LABEL == "" ]];
then
  sketchybar --set $NAME label.drawing=off    \
                         icon.padding_right=8
else
  sketchybar --set $NAME label="${LABEL}"     \
                         label.drawing=on     \
                         icon.padding_right=4
fi
