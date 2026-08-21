#!/bin/bash

# Color palette resolver.
#
# Everything under ~/.config/sketchybar is a read-only symlink into the nix
# store - the derivation in programs/sketchybar.nix ends with `chmod -R a-w`.
# So theme-switch.sh cannot rewrite a `source` line in sketchybarrc or
# common.sh the way it used to; sed exits 1 on a store symlink.
#
# The palette *choice* therefore lives in a mutable state file outside the
# store, holding just a name. This file reads it and sources the matching
# palette, so sketchybarrc and common.sh source this instead of a fixed one.
#
# Falls back to catppuccin whenever the state file is missing, empty, holds
# something that is not a bare palette name, or names a palette that is gone -
# a bad write can dull the colors but must never stop the bar from starting.

SKETCHYBAR_THEME_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/sketchybar/theme"
SKETCHYBAR_THEME=catppuccin

if [[ -r "$SKETCHYBAR_THEME_STATE" ]]; then
    read -r SKETCHYBAR_THEME < "$SKETCHYBAR_THEME_STATE" || SKETCHYBAR_THEME=catppuccin
fi

# Bare name only - the value is interpolated into a path just below.
if [[ ! "$SKETCHYBAR_THEME" =~ ^[A-Za-z0-9_-]+$ ]] ||
   [[ ! -r "$HOME/.config/sketchybar/colors/$SKETCHYBAR_THEME.sh" ]]; then
    SKETCHYBAR_THEME=catppuccin
fi

export SKETCHYBAR_THEME
source "$HOME/.config/sketchybar/colors/$SKETCHYBAR_THEME.sh"
