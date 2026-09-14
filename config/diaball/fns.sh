#!/bin/zsh

# Functions
function git-del-tag() {
	regex="$1"
	# Get a list of all Git tags that match the regular expression
	tags=$(git tag | grep -E $regex)
	echo "Will delete the following tags:"
	echo "------"
	echo $tags
	echo "------"
	printf "Are you sure? (y/n): "
	read confirm
	echo ""
	if [ $confirm != "y" ]; then
		echo "Aborting"
		return
	fi
	while IFS= read -r tag; do
		echo "Deleting $tag ..."
		git push --delete origin $tag
		git tag --delete $tag
		echo ""
	done <<<"$tags"
}

function print-colors() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# ----- Common functions ------

function git_root_dir() {
  git rev-parse --show-toplevel 2&> /dev/null
}

function get_dir_title(){
  local USE_ICON=${1:-""}
  local home_icon=$([[ -z $USE_ICON ]] && echo "~" || echo " ")
  local git_icon=$([[ -z $USE_ICON ]] && echo "" || echo " ")
  local result="${PWD/#$HOME/$home_icon}"
  local gitFolder=$(git_root_dir)
  if [ ! -z "$gitFolder" ]; then
    result="${git_icon}$(basename ${gitFolder})"
  fi
  echo $result
}

function set_title_precmd(){
  local result=$(get_dir_title 1)
  echo -ne "\033]0;${result}\007"
}

function set_title_preexec(){
  local cmd=$(echo $1 | cut -d' ' -f 1)
  local dir=$(get_dir_title 1)
  echo -ne "\033]2;$dir: $cmd\007"
} 

function profile_zsh() {
  time ZSH_DEBUGRC=1 zsh -i -c exit
}

function toggle_taskfile() {
  if [[ -z $TASKFILE_ON ]]; then
    export TASKFILE_ON=1
    alias task="$GOPATH/bin/taskfile"
    echo "Taskfile is now enabled"
  else
    unset TASKFILE_ON
    unalias task
    echo "Taskfile is now disabled"
  fi
}

function zellij_tab_name_update() {
  if [[ -n $ZELLIJ ]]; then
    local tab_name="$(get_dir_title)"
    command nohup zellij action rename-tab "$tab_name" >/dev/null 2>&1
  fi
}

function switch_starship_prompt() {
  local state="$HOME/.cache/starship-variant"
  mkdir -p "$(dirname "$state")"
  local current next
  current=$(cat "$state" 2>/dev/null || echo filled)
  if [ "$current" = "filled" ]; then
    next=plain
  else
    next=filled
  fi
  echo "$next" > "$state"
  export STARSHIP_CONFIG="$HOME/.config/starship/${next}.toml"
  echo "Switched to $next Starship prompt"
}

function vol_up() {
  local change="$1"
  m volume --set $(expr $(m volume | sed 's/Vol: \([0-9]*\).*/\1/') + $change)
}

function vol_down() {
  local change="$1"
  m volume --set $(expr $(m volume | sed 's/Vol: \([0-9]*\).*/\1/') - $change)
}

# ----- AeroSpace ------

# Restart AeroSpace under the launchd agent that owns it.
#
# org.nixos.aerospace is the only launcher that passes --config-path, so starting
# AeroSpace.app any other way - Spotlight, Launchpad, or opening it again after
# the menu-bar disable toggle - brings up a second server on AeroSpace's built-in
# defaults. That one hijacks the socket, so the CLI and SketchyBar both start
# answering from it and the six workspaces are replaced by the stock 1-10 + A-Z.
# Killing the stray is not enough on its own: the surviving server never re-binds
# the socket and starts refusing connections, so the agent is kicked either way.
function restart_aerospace() {
  local agent="gui/$(id -u)/org.nixos.aerospace"
  local strays i
  strays=$(ps -Ao pid=,command= | grep '[A]eroSpace.app/Contents/MacOS/AeroSpace' | grep -v -- '--config-path' | awk '{print $1}')

  if [ -n "$strays" ]; then
    echo "Killing stray AeroSpace without --config-path: $(echo $strays | tr '\n' ' ')"
    echo "$strays" | xargs kill
  fi

  launchctl kickstart -k "$agent" || {
    echo "Could not kick $agent"
    return 1
  }

  for i in {1..20}; do
    aerospace list-workspaces --focused >/dev/null 2>&1 && break
    sleep 0.25
  done

  if ! aerospace list-workspaces --focused >/dev/null 2>&1; then
    echo "AeroSpace did not come back up - check: launchctl print $agent"
    return 1
  fi

  # Windows opened while the stray was in charge kept its workspace assignments,
  # so put every one of them back through the rules.
  aerospace run-callback --for-every-window on-window-detected >/dev/null 2>&1
  pgrep -x sketchybar >/dev/null && sketchybar --reload

  echo "AeroSpace restarted: $(aerospace list-workspaces --all | tr '\n' ' ')"
}
