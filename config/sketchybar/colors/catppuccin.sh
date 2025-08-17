#!/bin/bash

source "$HOME/.config/sketchybar/utils.sh"

# Color Palette -- Catppuccin Macchiato
export BLACK=$(ch_hexfull "#181926")
export WHITE=$(ch_hexfull "#cad3f5")
export ROSEWATER=$(ch_hexfull "#f4dbd6")
export FLAMINGO=$(ch_hexfull "#f0c6c6")
export PINK=$(ch_hexfull "#f5bde6")
export MAUVE=$(ch_hexfull "#c6a0f6")
export RED=$(ch_hexfull "#ed8796")
export MAROON=$(ch_hexfull "#ee99a0")
export PEACH=$(ch_hexfull "#f5a97f")
export YELLOW=$(ch_hexfull "#eed49f")
export GREEN=$(ch_hexfull "#a6da95")
export TEAL=$(ch_hexfull "#8bd5ca")
export SKY=$(ch_hexfull "#91d7e3")
export SAPPHIRE=$(ch_hexfull "#7dc4e4")
export BLUE=$(ch_hexfull "#8aadf4")
export LAVENDER=$(ch_hexfull "#b7bdf8")
export GREY=$(ch_hexfull "#939ab7")
export TRANSPARENT=0x00000000

export TEXT=$WHITE
export SUBTEXT1=$(ch_hexfull "#b8c0e0")
export SUBTEXT0=$(ch_hexfull "#a5adcb")
export SURFACE2=$(ch_hexfull "#5b6078")
export SURFACE1=$(ch_hexfull "#494d64")
export SURFACE0=$(ch_hexfull "#363a4f")
export BASE=$(ch_hexfull "#24273a")
export MANTLE=$(ch_hexfull "#1e2030")
export CRUST=$(ch_hexfull "#181926")

export ITEM_COLOR=$WHITE
export SUBITEM_COLOR=$(ch_transp $ITEM_COLOR "88")
export ITEM_BG_COLOR=$TRANSPARENT

# General bar colors
export ICON_COLOR=$WHITE  # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export ALT_LABEL_COLOR=$WHITE

export ACCENT_COLOR=$MAROON

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
export BLACK_ALPHA3=0x33000000
export WHITE_ALPHA0=0xddffffff
export WHITE_ALPHA1=0xaaffffff
export WHITE_ALPHA2=0x77ffffff
export WHITE_ALPHA3=0x33ffffff

export BAR_COLOR=$BASE_ALPHA0
export POPUP_BG_COLOR=$SURFACE1
export POPUP_BORDER_COLOR=$PEACH

export SHADOW_COLOR=$(ch_transp $BLACK "88")

# ============================================================================
# SEMANTIC COLOR MAPPINGS
# ============================================================================

# LEFT SECTION - Navigation & Spaces
export SPACE_NORMAL=$WHITE
export SPACE_ACTIVE=$MAROON

# CENTER SECTION - Active Context
export CONTEXT_APP=$GREEN         # Active application indicator
export CONTEXT_MEDIA=$BLUE        # Media controls and display
export CONTEXT_WM_BSP=$SKY        # Window manager: BSP mode
export CONTEXT_WM_STACK=$PEACH    # Window manager: Stack mode
export CONTEXT_WM_FLOAT=$LAVENDER # Window manager: Float mode

# RIGHT SECTION - Information & Status
export INFO_PRIMARY=$YELLOW # Primary system stats (CPU, primary indicators)
export INFO_SECONDARY=$GREY # Secondary system elements (volume icon, muted states)
export INFO_ACCENT=$BLUE    # Interactive system elements (sliders, highlights)
export INFO_TIME=$SURFACE1  # Time/date text elements
export INFO_TIME_BG=$BASE   # Time/date background elements
export PROD_PRIMARY=$MAROON # Primary productivity indicators
export PROD_SECONDARY=$TEAL # Secondary productivity elements
export PROD_URGENT=$RED     # Urgent notifications/alerts

# UNIVERSAL - Cross-section
export SECTION_BG=$BASE                       # Default section backgrounds
export SECTION_BG_ALPHA=$BASE_ALPHA0          # Alpha section backgrounds
export GROUP_BG=$BASE                         # Group backgrounds
export GROUP_BORDER=$(ch_transp "$PINK" "99") # Group backgrounds
export GROUP_LIGHT_BG=$(ch_transp "$MAUVE" "44")
export GROUP_LIGHT_BORDER=$(ch_transp "$MAUVE" "66")
export STATUS_SUCCESS=$GREEN  # Success states, positive indicators
export STATUS_WARNING=$YELLOW # Warning states, attention needed
export STATUS_ERROR=$RED      # Error states, critical issues
export STATUS_INFO=$BLUE      # Information states, neutral info
export STATUS_NEUTRAL=$GREY   # Neutral states, inactive elements
