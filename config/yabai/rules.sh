#!/usr/bin/env bash

remove_all_rules() {
  while [[ $(yabai -m rule --list | jq length) -gt 0 ]]; do
    yabai -m rule --remove 0
  done
}

remove_all_rules

# Set up rules for associating apps with spaces
yabai -m rule --add app="^kitty$" space=code1
yabai -m rule --add app="^Code$" space=code2
yabai -m rule --add app="^pgAdmin 4$" space=code2
yabai -m rule --add app="^Postman$" space=code2

yabai -m rule --add app="^Google Chrome$" title="Maulik$" space=browse1
yabai -m rule --add app="^Notion$" space=browse1
yabai -m rule --add app="^Google Chrome$" title!="Maulik$" space=browse2
yabai -m rule --add app="^Firefox$" space=browse2

yabai -m rule --add app="^Slack$" space=comm
yabai -m rule --add app="^Microsoft Outlook$" space=comm
yabai -m rule --add app="^Microsoft Teams$" space=comm

yabai -m rule --add app="^1Password$" space=misc manage=off
yabai -m rule --add app="^Music$" space=misc
yabai -m rule --add app="^Messages$" space=misc manage=off
yabai -m rule --add app="^WhatsApp$" space=misc manage=off
yabai -m rule --add app="^Telegram$" space=misc manage=off

# Layout management exceptions
yabai -m rule --add app="^System Settings$" manage=off
yabai -m rule --add app="^System Preferences$" manage=off
yabai -m rule --add app="^FortiClient$" manage=off
yabai -m rule --add app="^Calculator$" manage=off
yabai -m rule --add app="^Dictionary$" manage=off
yabai -m rule --add app="^App Store$" manage=off
yabai -m rule --add app="^Activity Monitor$" manage=off
yabai -m rule --add app="^Software Update$" manage=off
yabai -m rule --add title="About This Mac" manage=off
yabai -m rule --add app="^Finder$" manage=off
yabai -m rule --add app="^Archive Utility$" manage=off
