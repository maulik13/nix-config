#!/bin/bash

function ch_transp() {
  printf '0x%x' "$(($1 & 0x00ffffff | 0x${2}000000))"
}

function ch_hexfull() {
  local hex_color="${1#\#}"
  printf '0xff%s' "$hex_color"
}
