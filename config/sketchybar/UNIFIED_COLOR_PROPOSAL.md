# Unified Color System Proposal for SketchyBar

## Overview
This proposal outlines a unified color system that enables seamless theme switching between Catppuccin and Rose Pine themes by introducing semantic color categories mapped to the three main sections of the bar.

## Current Structure Analysis

### Three Main Sections
1. **LEFT**: Spaces and navigation (OS icon, spaces, space controls)
2. **CENTER**: Active context (window manager mode, active app, media)  
3. **RIGHT**: Information panels (time/date, system stats, productivity)

### Current Color Usage Patterns
- **LEFT**: Predominantly MAUVE (primary), with space-specific accent colors
- **CENTER**: Functional state colors (GREEN for apps, BLUE for media, SKY/PEACH/LAVENDER for modes)
- **RIGHT**: Status colors (YELLOW for CPU, GREY for volume, MAROON/TEAL for productivity)

## Proposed Unified Color Categories

### Section-Based Color Mapping

#### LEFT Section Colors (Navigation & Spaces)
```bash
# Primary navigation colors
export NAV_PRIMARY=$MAUVE           # Main navigation elements (OS icon, space backgrounds)
export NAV_ACCENT=$BLUE             # Space highlights and selection states
export NAV_MUTED=$WHITE_ALPHA2      # Secondary navigation elements (space add button)

# Space-specific colors (maintain current array but make it semantic)
export SPACE_COLORS=($NAV_ACCENT $STATUS_SUCCESS $STATUS_ERROR $STATUS_WARNING $NAV_PRIMARY $INFO_ACCENT $STATUS_WARNING $INFO_SECONDARY $TEXT)
```

#### CENTER Section Colors (Active Context)
```bash
# Application and context colors
export CONTEXT_APP=$GREEN           # Active application
export CONTEXT_MEDIA=$BLUE          # Media controls
export CONTEXT_WM_BSP=$SKY          # Window manager: BSP mode
export CONTEXT_WM_STACK=$PEACH      # Window manager: Stack mode  
export CONTEXT_WM_FLOAT=$LAVENDER   # Window manager: Float mode
```

#### RIGHT Section Colors (Information & Status)
```bash
# System information colors
export INFO_PRIMARY=$YELLOW         # Primary system stats (CPU)
export INFO_SECONDARY=$GREY         # Secondary system elements (volume icon)
export INFO_ACCENT=$BLUE            # Interactive system elements (volume slider)
export INFO_TIME=$SURFACE1          # Time/date elements
export INFO_TIME_BG=$BASE           # Time/date backgrounds

# Productivity and notification colors
export PROD_PRIMARY=$MAROON         # Primary productivity indicators
export PROD_SECONDARY=$TEAL         # Secondary productivity elements
export PROD_URGENT=$RED             # Urgent notifications/alerts
```

### Universal Colors (Cross-Section)
```bash
# Background and structural colors
export SECTION_BG=$BASE             # Default section backgrounds
export SECTION_BG_ALPHA=$BASE_ALPHA0 # Alpha section backgrounds
export GROUP_BG=$SURFACE1           # Group backgrounds
export GROUP_BORDER=$POPUP_BORDER_COLOR # Group borders

# Status semantic colors
export STATUS_SUCCESS=$GREEN        # Success states
export STATUS_WARNING=$YELLOW       # Warning states  
export STATUS_ERROR=$RED            # Error states
export STATUS_INFO=$BLUE            # Information states
export STATUS_NEUTRAL=$GREY         # Neutral states
```

## Implementation Strategy

### Phase 1: Add Semantic Color Variables to Theme Files
Each theme file (catppuccin.sh, rosepine.sh) now contains both the theme-specific color palette and semantic color mappings:

**catppuccin.sh semantic mappings:**
```bash
# LEFT SECTION - Navigation & Spaces
export NAV_PRIMARY=$MAUVE           # Main navigation elements
export NAV_ACCENT=$BLUE             # Space highlights and selection states
export NAV_MUTED=$WHITE_ALPHA2      # Secondary navigation elements

# CENTER SECTION - Active Context
export CONTEXT_APP=$GREEN           # Active application indicator
export CONTEXT_MEDIA=$BLUE          # Media controls and display
export CONTEXT_WM_BSP=$SKY          # Window manager: BSP mode
export CONTEXT_WM_STACK=$PEACH      # Window manager: Stack mode
export CONTEXT_WM_FLOAT=$LAVENDER   # Window manager: Float mode

# RIGHT SECTION - Information & Status
export INFO_PRIMARY=$YELLOW         # Primary system stats
export INFO_SECONDARY=$GREY         # Secondary system elements
export INFO_ACCENT=$BLUE            # Interactive system elements
export PROD_PRIMARY=$MAROON         # Primary productivity indicators
export PROD_SECONDARY=$TEAL         # Secondary productivity elements
export PROD_URGENT=$RED             # Urgent notifications/alerts
```

**rosepine.sh semantic mappings:**
```bash
# LEFT SECTION - Navigation & Spaces
export NAV_PRIMARY=$IRIS            # Purple accent for navigation
export NAV_ACCENT=$FOAM             # Teal for space highlights
export NAV_MUTED=$WHITE_ALPHA2      # Secondary navigation elements

# CENTER SECTION - Active Context
export CONTEXT_APP=$PINE            # Blue for active application
export CONTEXT_MEDIA=$FOAM          # Teal for media controls
export CONTEXT_WM_BSP=$FOAM         # Teal for BSP mode
export CONTEXT_WM_STACK=$GOLD       # Gold for stack mode
export CONTEXT_WM_FLOAT=$IRIS       # Purple for float mode

# RIGHT SECTION - Information & Status
export INFO_PRIMARY=$GOLD           # Gold for primary system stats
export INFO_SECONDARY=$MUTED        # Muted for secondary elements
export INFO_ACCENT=$FOAM            # Teal for interactive elements
export PROD_PRIMARY=$LOVE           # Pink for productivity
export PROD_SECONDARY=$PINE         # Blue for secondary productivity
export PROD_URGENT=$LOVE            # Pink for urgent states
```

### Phase 2: Update SPACE_COLORS Array
The SPACE_COLORS array in common.sh now uses semantic colors:
```bash
SPACE_COLORS=($NAV_ACCENT $STATUS_SUCCESS $STATUS_ERROR $STATUS_WARNING $NAV_PRIMARY $INFO_ACCENT $STATUS_WARNING $INFO_ACCENT $TEXT)
```

### Phase 3: Theme Switching Mechanism
Created `theme-switch.sh` script for easy theme switching:

```bash
#!/bin/bash
# Usage: ./theme-switch.sh [theme_name]

THEME=${1:-catppuccin}
CONFIG_DIR="$HOME/.config/sketchybar"

# Update sketchybarrc and common.sh to source the new theme
sed -i '' "s|source \".*colors/.*\.sh\"|source \"$CONFIG_DIR/colors/$THEME.sh\"|" "$CONFIG_DIR/sketchybarrc"
sed -i '' "s|source \".*colors/.*\.sh\"|source \"$CONFIG_DIR/colors/$THEME.sh\"|" "$CONFIG_DIR/common.sh"

# Reload sketchybar
sketchybar --reload
```

### Phase 4: Gradual Migration to Semantic Colors
Items and plugins can now be gradually updated to use semantic colors:

**Before:**
```bash
icon.color=$MAUVE
background.color=$BASE
```

**After:**
```bash
icon.color=$NAV_PRIMARY        # For left section items
background.color=$SECTION_BG   # For backgrounds
```

## Benefits

1. **Self-Contained Themes**: Each theme file contains everything needed - no external dependencies
2. **Simple Theme Switching**: Single script command to switch between themes  
3. **Theme-Specific Personality**: Each theme can map semantic colors to their most appropriate colors
4. **Maintainability**: Semantic colors provide consistent meaning across themes
5. **Backward Compatibility**: Existing color variables remain unchanged
6. **Easy Extension**: Adding new themes only requires creating a new theme file with semantic mappings

## Migration Path

1. ✅ **Add semantic color variables to catppuccin.sh and rosepine.sh**
2. ✅ **Update SPACE_COLORS array in common.sh to use semantic colors**
3. ✅ **Create theme-switch.sh script for easy theme switching**
4. **Gradually migrate items and plugins to use semantic colors**
5. **Test theme switching functionality**

## Usage

### Switching Themes
```bash
# Switch to Rose Pine theme
./theme-switch.sh rosepine

# Switch to Catppuccin theme  
./theme-switch.sh catppuccin

# List available themes
./theme-switch.sh invalid_theme  # Shows available themes
```

### Example Migration
Items can now be gradually updated to use semantic colors:

**Old approach (theme-specific):**
```bash
# items/os-icon.sh
icon.color=$MAUVE
background.color=$BASE
```

**New approach (semantic):**
```bash  
# items/os-icon.sh
icon.color=$NAV_PRIMARY      # Works with both themes
background.color=$SECTION_BG # Consistent across themes
```

## Implementation Complete

The unified color system is now implemented with:
- ✅ Semantic color variables in both theme files
- ✅ Theme-specific color personalities (Catppuccin uses MAUVE for navigation, Rose Pine uses IRIS)
- ✅ Unified SPACE_COLORS array using semantic variables
- ✅ Theme switching script with validation and error handling
- ✅ Self-contained theme files requiring no external dependencies

This approach ensures visual hierarchy and semantic meaning remain consistent across themes while allowing each theme to express its unique personality through appropriate color choices.