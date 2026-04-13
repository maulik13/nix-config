#!/usr/bin/env bash

# Define space labels
declare -a SPACE_LABELS=(
  [1]="code1"
  [2]="code2"
  [3]="browse1"
  [4]="browse2"
  [5]="comm"
  [6]="misc"
)

# Function to get the current number of spaces
get_space_count() {
  yabai -m query --spaces | jq '. | length'
}

# Function to create a new space
create_space() {
  yabai -m space --create
}

# Function to remove the last space
remove_last_space() {
  last_space=$(yabai -m query --spaces | jq '.[-1].index')
  echo "Removing space $last_space..."
  yabai -m space --destroy $last_space
}

# Function to get the number of displays
get_display_count() {
  yabai -m query --displays | jq '. | length'
}

# Function to move a space to a specific display
move_space_to_display() {
  space=$1
  display=$2
  yabai -m space $space --display $display
}

# Get the current number of spaces
current_spaces=$(get_space_count)

# Ensure we have exactly 6 spaces
if [ $current_spaces -lt 6 ]; then
  # Create spaces until we have 6
  while [ $(get_space_count) -lt 6 ]; do
    create_space
  done
fi

# --- Label and assign display ---
display_count=$(get_display_count)
# We set labels and display here before removing extras
#   otherwise if space distribution is not correct then we will get errors
# Set labels for all 6 spaces
assign_labels() {
  display_id=1
  for i in {1..6}; do
    if [[ $i -gt 3 && $display_count -gt 1 ]]; then
      display_id=2
    fi
    echo "Assigning label=${SPACE_LABELS[$i]} and display=${display_id} to space=${i}"
    yabai -m space $i --label "${SPACE_LABELS[$i]}" --display $display_id
  done
}

verify_labels() {
  local all_ok=true
  for i in {1..6}; do
    actual_label=$(yabai -m query --spaces --space $i | jq -r '.label')
    if [[ -z "$actual_label" || "$actual_label" == "null" || "$actual_label" != "${SPACE_LABELS[$i]}" ]]; then
      echo "Warning: space $i has label='$actual_label', expected='${SPACE_LABELS[$i]}'"
      all_ok=false
    fi
  done
  $all_ok
}

assign_labels

max_retries=3
retry=0
while ! verify_labels && [[ $retry -lt $max_retries ]]; do
  retry=$((retry + 1))
  echo "Retrying label assignment (attempt $retry/$max_retries)..."
  sleep 1
  assign_labels
done

if ! verify_labels; then
  echo "Error: Failed to assign all labels after $max_retries retries."
fi

if [[ $current_spaces -gt 6 ]]; then
  # Remove spaces until we have 6
  max_tries=10
  tries=0
  while [ $(get_space_count) -gt 6 ] && [ $tries -lt $max_tries ]; do
    remove_last_space
    tries=$((tries + 1))
    if [ $? -ne 0 ]; then
      echo "Error: Unable to remove space. Exiting loop."
      break
    fi
  done

  if [ $tries -ge $max_tries ]; then
    echo "Warning: Reached maximum tries ($max_tries) while removing spaces."
  fi
fi

# Set space 4 to stacked layout and space 6 to float
yabai -m space 4 --layout stack
yabai -m space 6 --layout float

echo "Spaces adjusted and labeled. Current number of spaces: $(get_space_count)"

# Print current space labels
echo "Current space labels:"
yabai -m query --spaces | jq -r '.[] | "\(.index): \(.label)"'

echo "Space assignment complete."

# Verify the assignments
echo "Current space assignments:"
yabai -m query --spaces | jq -r '.[] | "Space \(.index) on Display \(.display)"'
