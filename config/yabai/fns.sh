#!/usr/bin/env bash

load() {
	source $HOME/.config/yabai/spaces.sh
	source $HOME/.config/yabai/rules.sh
	yabai -m rule --apply
	sketchybar --reload
}
