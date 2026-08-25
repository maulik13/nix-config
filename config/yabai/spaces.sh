#!/usr/bin/env bash
#
# Reconcile macOS spaces with the layout below, then label them.
#
# Sourced by fns.sh:load - returns non-zero when the desired layout could not be
# reached, so the caller can report it instead of failing silently.

# Desired spaces, in order: index -> label
declare -a SPACE_LABELS=(
  [1]="code1"
  [2]="ai"
  [3]="browse1"
  [4]="browse2"
  [5]="comm"
  [6]="misc"
)
WANTED_SPACES=6

# Spaces up to SPLIT_AFTER stay on display 1, the rest move to display 2 when
# a second display is connected.
SPLIT_AFTER=3

# Layout override per space index. Spaces not listed keep their current layout.
declare -a SPACE_LAYOUTS=(
  [4]="stack"
  [6]="float"
)

# Space create/destroy goes through Mission Control and is not instant; poll
# this many times (0.2s apart) for the space count to actually change.
SPACE_SETTLE_TRIES=15

space_count() { yabai -m query --spaces | jq 'length'; }
display_count() { yabai -m query --displays | jq 'length'; }
space_display() { yabai -m query --spaces --space "$1" | jq -r '.display'; }
space_label() { yabai -m query --spaces --space "$1" | jq -r '.label'; }

# Index of the space currently holding label $1, empty when nothing holds it.
label_owner() {
  yabai -m query --spaces | jq -r --arg l "$1" 'map(select(.label == $l)) | .[0].index // empty'
}

# wait_for_count <test-op> <n>: wait until the space count satisfies e.g. -ge 5
wait_for_count() {
  local op=$1 want=$2 try=0
  while [ "$try" -lt "$SPACE_SETTLE_TRIES" ]; do
    [ "$(space_count)" "$op" "$want" ] && return 0
    sleep 0.2
    try=$((try + 1))
  done
  return 1
}

# Creating a space needs the scripting addition. The request can be accepted and
# then silently ignored (unsupported macOS build, scripting addition not loaded
# into Dock), so verify the count moved rather than looping until it does - that
# loop never terminates and the whole reload hangs.
create_missing_spaces() {
  local count
  count=$(space_count)
  while [ "$count" -lt "$WANTED_SPACES" ]; do
    echo "Creating space $((count + 1))..."
    yabai -m space --create
    if ! wait_for_count -ge $((count + 1)); then
      echo "Error: 'yabai -m space --create' had no effect - stuck at $count space(s)."
      echo "       Creating spaces needs a working scripting addition; try"
      echo "       'sudo yabai --load-sa', or add the missing $((WANTED_SPACES - count))"
      echo "       space(s) by hand from Mission Control."
      return 1
    fi
    count=$(space_count)
  done
  return 0
}

remove_extra_spaces() {
  local count last
  count=$(space_count)
  while [ "$count" -gt "$WANTED_SPACES" ]; do
    last=$(yabai -m query --spaces | jq '.[-1].index')
    echo "Removing space $last..."
    yabai -m space --destroy "$last"
    if ! wait_for_count -le $((count - 1)); then
      echo "Error: could not destroy space $last - stopping at $count space(s)."
      return 1
    fi
    count=$(space_count)
  done
  return 0
}

# Labels are unique, so a label still held by another space has to be released
# before it can be re-used ('--label' with no argument clears it).
assign_labels() {
  local count i want owner rc=0
  count=$(space_count)
  for i in $(seq 1 "$WANTED_SPACES"); do
    [ "$i" -le "$count" ] || continue
    want="${SPACE_LABELS[$i]}"
    owner=$(label_owner "$want")
    [ "$owner" = "$i" ] && continue
    if [ -n "$owner" ]; then
      echo "Releasing label '$want' from space $owner"
      yabai -m space "$owner" --label || rc=1
    fi
    echo "Labelling space $i as '$want'"
    yabai -m space "$i" --label "$want" || rc=1
  done
  return $rc
}

# Only checks spaces that exist, so the retry below reacts to label conflicts
# rather than to spaces macOS refused to create.
verify_labels() {
  local count i actual rc=0
  count=$(space_count)
  for i in $(seq 1 "$WANTED_SPACES"); do
    [ "$i" -le "$count" ] || continue
    actual=$(space_label "$i")
    if [ "$actual" != "${SPACE_LABELS[$i]}" ]; then
      echo "Warning: space $i has label='$actual', expected='${SPACE_LABELS[$i]}'"
      rc=1
    fi
  done
  return $rc
}

report_missing_spaces() {
  local count i rc=0
  count=$(space_count)
  for i in $(seq 1 "$WANTED_SPACES"); do
    [ "$i" -gt "$count" ] || continue
    echo "Warning: space $i ('${SPACE_LABELS[$i]}') does not exist"
    rc=1
  done
  return $rc
}

# Moving the trailing spaces to display 2 keeps the indices stable, because yabai
# numbers spaces display by display. Only move what is not already in place.
assign_displays() {
  local displays count i target current rc=0
  displays=$(display_count)
  [ "$displays" -lt 2 ] && return 0
  count=$(space_count)
  for i in $(seq 1 "$WANTED_SPACES"); do
    [ "$i" -le "$count" ] || continue
    if [ "$i" -le "$SPLIT_AFTER" ]; then target=1; else target=2; fi
    current=$(space_display "$i")
    [ "$current" = "$target" ] && continue
    echo "Moving space $i ('${SPACE_LABELS[$i]}') to display $target"
    yabai -m space "$i" --display "$target" || rc=1
  done
  return $rc
}

apply_layouts() {
  local count i layout rc=0
  count=$(space_count)
  for i in $(seq 1 "$WANTED_SPACES"); do
    [ "$i" -le "$count" ] || continue
    layout="${SPACE_LAYOUTS[$i]}"
    [ -n "$layout" ] || continue
    yabai -m space "$i" --layout "$layout" || rc=1
  done
  return $rc
}

spaces_rc=0

create_missing_spaces || spaces_rc=1
remove_extra_spaces || spaces_rc=1

# A label change can be rejected while macOS is still settling after a space was
# added or removed, so retry a couple of times before giving up.
assign_labels || spaces_rc=1
retry=0
while ! verify_labels >/dev/null && [ "$retry" -lt 2 ]; do
  retry=$((retry + 1))
  echo "Retrying label assignment (attempt $retry/2)..."
  sleep 0.5
  assign_labels
done
verify_labels || spaces_rc=1
report_missing_spaces || spaces_rc=1

assign_displays || spaces_rc=1
apply_layouts || spaces_rc=1

echo "Spaces: $(space_count) of $WANTED_SPACES wanted, across $(display_count) display(s)"
yabai -m query --spaces | jq -r '.[] | "  space \(.index): label=\(.label) display=\(.display) layout=\(.type)"'

return "$spaces_rc" 2>/dev/null || exit "$spaces_rc"
