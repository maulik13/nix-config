# 󰄛

# sketchybar --add item bar.start left \
#   --set bar.start \
#   icon=" " \
#   icon.color=$MANTLE \
#   icon.font.size=36 \
#   icon.y_offset=0 \
#   padding_left=3 \
#   padding_right=0 \
#   label.drawing=off \
#   icon.padding_left=0 \
#   icon.padding_right=0
#
# sketchybar --add item bar.start1 left \
#   --set bar.start1 \
#   background.color=$MANTLE \
#   background.height=36 \
#   background.corner_radius=0 \
#   y_offset=-0 \
#   icon="" \
#   icon.color=$MANTLE \
#   icon.font.size=24 \
#   padding_left=-18 \
#   padding_right=0 \
#   label.drawing=off \
#   icon.padding_left=0 \
#   icon.padding_right=4
#
sketchybar --add item command.logo left \
  --set command.logo \
  background.border_width=2 \
  background.height=36 \
  background.corner_radius=10 \
  background.border_color=$ACCENT_COLOR \
  background.color=$(ch_transp "$ACCENT_COLOR" "55") \
  icon.font.size=36 \
  icon="󰄛" \
  icon.color=$YELLOW \
  icon.padding_left=5 \
  padding_left=0 \
  icon.padding_right=5 \
  icon.y_offset=-3 \
  label.drawing=off \
  click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
  "${POPUP_COMMON_PROPS[@]}"

sketchybar --add item command.preferences popup.command.logo \
  --set command.preferences icon="􀣌 " \
  label="Settings" \
  click_script="open -a 'System Preferences'; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.activity popup.command.logo \
  --set command.activity icon="􀫥 " \
  label="Monitor" \
  click_script="open -a 'Activity Monitor'; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.lock popup.command.logo \
  --set command.lock icon="􀆼 " \
  label="Sleep" \
  click_script="pmset displaysleepnow; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.reload popup.command.logo \
  --set command.reload icon="􀚂 " \
  label="Reload Bar" \
  click_script="sketchybar --reload; sketchybar -m --set command.logo popup.drawing=off"
