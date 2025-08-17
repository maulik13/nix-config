#!/bin/bash

source "$HOME/.config/sketchybar/utils.sh"

# Color Palette -- Rose Pine Moon
export BLACK=$(ch_hexfull "#232136")
export WHITE=$(ch_hexfull "#e0def4")
export LOVE=$(ch_hexfull "#eb6f92")
export GOLD=$(ch_hexfull "#f6c177")
export ROSE=$(ch_hexfull "#ea9a97")
export PINE=$(ch_hexfull "#3e8fb0")
export FOAM=$(ch_hexfull "#9ccfd8")
export IRIS=$(ch_hexfull "#c4a7e7")
export MUTED=$(ch_hexfull "#6e6a86")
export SUBTLE=$(ch_hexfull "#908caa")
export TRANSPARENT=0x00000000

export TEXT=$WHITE
export HIGHLIGHT_LOW=$(ch_hexfull "#2a283e")
export HIGHLIGHT_MED=$(ch_hexfull "#44415a")
export HIGHLIGHT_HIGH=$(ch_hexfull "#56526e")
export SUBTEXT1=$SUBTLE
export SUBTEXT0=$MUTED
export SURFACE2=$(ch_hexfull "#393552")
export SURFACE1=$(ch_hexfull "#2a273f")
export SURFACE0=$(ch_hexfull "#26233a")
export BASE=$(ch_hexfull "#232136")
export MANTLE=$(ch_hexfull "#1e1e2e")
export CRUST=$(ch_hexfull "#16141f")

export ITEM_COLOR=$WHITE
export SUBITEM_COLOR=$(ch_transp $ITEM_COLOR "88")
export ITEM_BG_COLOR=$TRANSPARENT

# General bar colors
export ICON_COLOR=$WHITE  # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export ALT_LABEL_COLOR=$WHITE

export ACCENT_COLOR=$LOVE
export SECONDARY_COLOR=$PINE

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
export SPACE_BACKGROUND=$(ch_transp "$CRUST" "88")
export SPACE_SELECTED=$WHITE
export TSPACE_DESELECTED=$HIGHLIGHT_MED
export SPACE_DESELECTED_BG=$SURFACE1

export POPUP_BG_COLOR=$SURFACE1
export POPUP_BORDER_COLOR=$GOLD

export SHADOW_COLOR=$(ch_transp $BLACK "88")

# ============================================================================
# SEMANTIC COLOR MAPPINGS
# ============================================================================

# LEFT SECTION - Navigation & Spaces
export SPACE_NORMAL=$WHITE
export SPACE_ACTIVE=$PINE
export SPACE_BG_COLOR=$(ch_transp "$MAUVE" "44")
export SPACE_BORDER_COLOR=$(ch_transp "$MAUVE" "66")

# CENTER SECTION - Active Context
export CONTEXT_APP=$PINE      # Blue for active application indicator
export CONTEXT_MEDIA=$FOAM    # Teal for media controls and display
export CONTEXT_WM_BSP=$FOAM   # Teal for window manager: BSP mode
export CONTEXT_WM_STACK=$GOLD # Gold for window manager: Stack mode
export CONTEXT_WM_FLOAT=$IRIS # Purple for window manager: Float mode

# RIGHT SECTION - Information & Status
export INFO_PRIMARY=$GOLD    # Gold for primary system stats (CPU, primary indicators)
export INFO_SECONDARY=$MUTED # Muted for secondary system elements (volume icon, muted states)
export INFO_ACCENT=$FOAM     # Teal for interactive system elements (sliders, highlights)
export INFO_TIME=$SURFACE1   # Time/date text elements
export INFO_TIME_BG=$BASE    # Time/date background elements
export PROD_PRIMARY=$LOVE    # Pink for primary productivity indicators
export PROD_SECONDARY=$PINE  # Blue for secondary productivity elements
export PROD_URGENT=$LOVE     # Pink for urgent notifications/alerts

# UNIVERSAL - Cross-section
export SECTION_BG=$BASE                       # Default section backgrounds
export SECTION_BG_ALPHA=$BASE_ALPHA0          # Alpha section backgrounds
export GROUP_BG=$BASE                         # Group backgrounds
export GROUP_BORDER=$(ch_transp "$ROSE" "99") # Group backgrounds
export GROUP_LIGHT_BG=$(ch_transp "$IRIS" "44")
export GROUP_LIGHT_BORDER=$(ch_transp "$IRIS" "66")
export STATUS_SUCCESS=$PINE  # Blue for success states, positive indicators
export STATUS_WARNING=$GOLD  # Gold for warning states, attention needed
export STATUS_ERROR=$LOVE    # Pink for error states, critical issues
export STATUS_INFO=$FOAM     # Teal for information states, neutral info
export STATUS_NEUTRAL=$MUTED # Muted for neutral states, inactive elements
