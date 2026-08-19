#!/usr/bin/env bash
#
# Rebuild the yabai rule set.
#
# yabai rejects a rule outright when its space= label does not exist, which
# silently drops everything else the rule sets (manage=off in particular). Rules
# are added through add_rule() here so a missing label only costs the space
# assignment, and the loss gets reported.
#
# Sourced by fns.sh:load - returns non-zero if any rule was degraded or skipped.

# Safety net so a rule that refuses to be removed cannot spin forever.
MAX_RULE_REMOVALS=200

remove_all_rules() {
  local removed=0
  while [ "$(yabai -m rule --list | jq 'length')" -gt 0 ]; do
    yabai -m rule --remove 0 || break
    removed=$((removed + 1))
    if [ "$removed" -ge "$MAX_RULE_REMOVALS" ]; then
      echo "Warning: stopped after removing $removed rules, $(yabai -m rule --list | jq 'length') left"
      break
    fi
  done
}

EXISTING_LABELS=$(yabai -m query --spaces | jq -r '.[].label')
DEGRADED_RULES=""

space_label_exists() {
  printf '%s\n' "$EXISTING_LABELS" | grep -qxF -- "$1"
}

# True when the rule sets something beyond the window filters, i.e. it is still
# worth adding without its space assignment.
rule_has_property() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      app=* | app!=* | title=* | title!=* | role=* | role!=* | subrole=* | subrole!=*) ;;
      *) return 0 ;;
    esac
  done
  return 1
}

# add_rule <space-label|-> <rule arguments...>
add_rule() {
  local space=$1
  shift

  if [ "$space" = "-" ]; then
    yabai -m rule --add "$@"
    return 0
  fi

  if space_label_exists "$space"; then
    yabai -m rule --add "$@" space="$space"
    return 0
  fi

  DEGRADED_RULES="${DEGRADED_RULES}  space=$space  $*
"
  if rule_has_property "$@"; then
    yabai -m rule --add "$@"
  fi
  return 0
}

remove_all_rules

# Associate apps with spaces
add_rule code1 app="^kitty$"

add_rule code2 app="^Code$"
add_rule code2 app="^Claude"
add_rule code2 app="^pgAdmin 4$"
add_rule code2 app="^Postman$"

add_rule browse1 app="^Google Chrome$" title="Maulik$"
add_rule browse1 app="^Notion$"
add_rule browse1 app="draw.io"
add_rule browse2 app="^Google Chrome$" title!="Maulik$"
add_rule browse2 app="^Firefox$"

add_rule comm app="^Slack$"
add_rule comm app="^Microsoft Outlook$"
add_rule comm app="^Microsoft Teams$"

add_rule misc app="^1Password$" manage=off
add_rule misc app="^Music$"
add_rule misc app="^Messages$" manage=off
add_rule misc app="^WhatsApp$" manage=off
add_rule misc app="^Telegram$" manage=off
add_rule misc app="^FortiClient$" manage=off

# Layout management exceptions
add_rule - app="^System Settings$" manage=off
add_rule - app="^System Preferences$" manage=off
add_rule - app="^Calculator$" manage=off
add_rule - app="^Dictionary$" manage=off
add_rule - app="^App Store$" manage=off
add_rule - app="^Activity Monitor$" manage=off
add_rule - app="^Software Update$" manage=off
add_rule - title="About This Mac" manage=off
add_rule - app="^Archive Utility$" manage=off
add_rule - app="^Notes$" manage=off

rules_rc=0
if [ -n "$DEGRADED_RULES" ]; then
  echo "Warning: these rules lost their space assignment because the label does not exist:"
  printf '%s' "$DEGRADED_RULES"
  rules_rc=1
fi

echo "Rules loaded: $(yabai -m rule --list | jq 'length')"

return "$rules_rc" 2>/dev/null || exit "$rules_rc"
