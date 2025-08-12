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
  background.border_color=$MAUVE \
  background.color=0xff46276E \
  icon.font.size=36 \
  icon="󰄛" \
  icon.color=$MAUVE \
  icon.padding_left=5 \
  padding_left=0 \
  icon.padding_right=5 \
  icon.y_offset=-3 \
  label.drawing=off \
  click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
  popup.height=38 \
  popup.background.color=$MAUVE \
  popup.background.border_width=0 \
  popup.background.corner_radius=5 \
  popup.background.border_color=$PEACH \
  popup.background.shadow.color=$SHADOW_COLOR \
  popup.background.shadow.angle=270

sketchybar --add item command.preferences popup.command.logo \
  --set command.preferences icon="􀣌 " \
  icon.color=$SURFACE1 \
  label="Settings" \
  label.color=$SURFACE1 \
  click_script="open -a 'System Preferences'; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.activity popup.command.logo \
  --set command.activity icon="􀫥 " \
  icon.color=$SURFACE1 \
  label="Monitor" \
  label.color=$SURFACE1 \
  click_script="open -a 'Activity Monitor'; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.lock popup.command.logo \
  --set command.lock icon="􀆼 " \
  icon.color=$SURFACE1 \
  label="Sleep" \
  label.color=$SURFACE1 \
  click_script="pmset displaysleepnow; sketchybar -m --set command.logo popup.drawing=off"

sketchybar --add item command.reload popup.command.logo \
  --set command.reload icon="􀚂 " \
  icon.color=$SURFACE1 \
  label="Reload Bar" \
  label.color=$SURFACE1 \
  click_script="sketchybar --reload; sketchybar -m --set command.logo popup.drawing=off"
