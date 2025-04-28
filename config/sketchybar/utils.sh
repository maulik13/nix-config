#!/bin/bash

function ch_transp() {
  printf '0x%x' "$(($1 & 0x00ffffff | 0x${2}000000))"
}
