function vol_up() {
  local change="$1"
  m volume --set $(expr $(m volume | sed 's/Vol: \([0-9]*\).*/\1/') + $change)
}

function vol_down() {
  local change="$1"
  m volume --set $(expr $(m volume | sed 's/Vol: \([0-9]*\).*/\1/') - $change)
}

