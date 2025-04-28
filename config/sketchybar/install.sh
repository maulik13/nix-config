#!/bin/bash

# Install dependencies
VER=v2.0.19

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/$VER/sketchybar-app-font.ttf \
  -o $HOME/Library/Fonts/sketchybar-app-font.ttf

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/$VER/icon_map_fn.sh \
  -o ~/.config/sketchybar/plugins/icon_map.sh

printf "__icon_map \"$1\ \n echo \"$icon_result\"" >>~/.config/sketchybar/plugins/icon_map.sh

chmod +x ~/.config/sketchybar/plugins/icon_map.sh
