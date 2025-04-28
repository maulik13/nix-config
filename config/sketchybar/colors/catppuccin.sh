#!/bin/bash

source "$HOME/.config/sketchybar/utils.sh"

# Color Palette -- Catppuccin Macchiato
export BLACK=0xff181926
export WHITE=0xffcad3f5
export ROSEWATER=0xfff4dbd6
export FLAMINGO=0xfff0c6c6
export PINK=0xfff5bde6
export MAUVE=0xffc6a0f6
export RED=0xffed8796
export MAROON=0xffee99a0
export PEACH=0xfff5a97f
export YELLOW=0xffeed49f
export GREEN=0xffa6da95
export TEAL=0xff8bd5ca
export SKY=0xff91d7e3
export SAPPHIRE=0xff7dc4e4
export BLUE=0xff8aadf4
export LAVENDER=0xffb7bdf8
export GREY=0xff939ab7
export TRANSPARENT=0x00000000

export TEXT=$WHITE
export SUBTEXT1=0xffb8c0e0
export SUBTEXT0=0xffa5adcb
export SURFACE2=0xff5b6078
export SURFACE1=0xff494d64
export BASE=0xff24273a
export MANTLE=0xff1e2030
export CRUST=0xff181926

export ITEM_COLOR=$WHITE
export SUBITEM_COLOR=$(ch_transp $ITEM_COLOR "88")
export ITEM_BG_COLOR=$TRANSPARENT

# General bar colors
export ICON_COLOR=$WHITE  # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export ALT_LABEL_COLOR=$WHITE

export ACCENT_COLOR=$RED

export BASE_ALPHA0=$(ch_transp "$BASE" "dd")
export BASE_ALPHA1=$(ch_transp "$BASE" "aa")
export BASE_ALPHA2=$(ch_transp "$BASE" "77")
export BASE_ALPHA3=$(ch_transp "$BASE" "33")
export CRUST_ALPHA0=$(ch_transp "$CRUST" "dd")
export CRUST_ALPHA1=$(ch_transp "$CRUST" "aa")
export CRUST_ALPHA2=$(ch_transp "$CRUST" "77")
export CRUST_ALPHA3=$(ch_transp "$CRUST" "33")
export BLACK_ALPHA0=0xdd000000
export BLACK_ALPHA1=0xaa000000
export BLACK_ALPHA2=0x77000000
export WHITE_ALPHA0=0xddffffff
export WHITE_ALPHA1=0xaaffffff
export WHITE_ALPHA2=0x77ffffff
export WHITE_ALPHA3=0x33ffffff

export BAR_COLOR=$BASE_ALPHA0
export SPACE_BACKGROUND=$(ch_transp "$CRUST" "88")
export SPACE_SELECTED=0xffcdd6f4
export TSPACE_DESELECTED=0xff313244
export SPACE_DESELECTED_BG=$SURFACE1

export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$WHITE

export SHADOW_COLOR=$(ch_transp $BLACK "88")
