#!/bin/bash

source "$HOME/.config/sketchybar/common.sh"

# The chord banner: while one of the binding modes from darwin/aerospace.nix is
# armed, a small chip names it and a popup below the bar lists what the next key
# does. Nothing at all is drawn in main mode, so the bar looks exactly as it did
# before whenever no chord is in play.
#
# The cues live in a popup rather than in the label because they do not fit: laid
# out inline, the six workspace names measured 724px on a 1728pt bar and ran
# straight through the system group and the clock. Vertically they cost no bar
# width at all, and nothing else has to move or hide to make room.
#
# AeroSpace fires aerospace_mode_change on every transition, which is what makes
# the chip feel instant. The slow update_freq on top of that is a self-heal for
# the paths that fire no event - `aerospace mode ...` straight from the CLI, or
# AeroSpace restarting mid-chord - so neither a stale chip nor an orphaned popup
# can outlive its mode by more than a few seconds.
sketchybar --add event aerospace_mode_change

# Two fonts, two colors, one item: the icon slot carries the breadcrumb and the
# label carries the way out, which is the only way to make the mode name stand
# out from the cue underneath it without adding a second item to the bar.
sketchybar --add item chord_mode q \
  --set chord_mode \
  drawing=off \
  update_freq=5 \
  icon.font="VictorMono Nerd Font:SemiBold:17.0" \
  icon.color=$CONTEXT_WM \
  icon.padding_left=8 \
  icon.padding_right=8 \
  label.font="VictorMono Nerd Font:Medium:14.0" \
  label.color=$SUBITEM_COLOR \
  label.padding_left=0 \
  label.padding_right=8 \
  popup.align=center \
  popup.horizontal=off \
  "${POPUP_COMMON_PROPS[@]}" \
  script="$PLUGIN_DIR/chord_mode.sh" \
  --subscribe chord_mode aerospace_mode_change
