#!/bin/bash

# Alfred Theme Importer
# Usage: ./import-themes.sh
#
# themes/ holds vendored Alfred themes matching the two palettes the rest of
# the setup switches between (see config/sketchybar/theme-switch.sh):
# Catppuccin Macchiato, per catppuccin.flavor in shared/home.nix, in all three
# styles; and Rose Pine Moon, per config/sketchybar/colors/rosepine.sh.
#
#   upstream: https://github.com/catppuccin/alfred  (dist/)
#   commit:   b87457d487e54d6f241fdd8a073863d52f64d1cc  (2024-04-09)
#   sha256:   678f0b0a...1504  Catppuccin-default-macchiato.alfredappearance
#             4199a0a7...b115  Catppuccin-macOS-macchiato.alfredappearance
#             3d1acdb4...e80a  Catppuccin-modern-macchiato.alfredappearance
#
#   upstream: https://github.com/rose-pine/alfred  (dist/)
#   commit:   200d379e264c305c8fa1cda5b854e995562fedb2  (2026-06-25)
#   sha256:   947ab292...46a1  rose-pine-moon.alfredappearance
#
# Vendored rather than fetched so a fresh machine needs no network, and rather
# than managed by nix because neither home-manager, nix-darwin nor
# catppuccin/nix has an Alfred module - see below for why.
#
# Alfred owns its preferences bundle and assigns its own UUID to every imported
# theme (themes/theme.fileimport.<UUID>/theme.json), so these files cannot be
# symlinked into place the way the ~/.config trees are - there is no stable
# path to link to. Importing is the supported route: `open` hands the file to
# Alfred and Alfred does the copy.
#
# Idempotent - themes already present, matched on the name recorded inside the
# file, are skipped.

set -uo pipefail

THEMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/themes"
ALFRED_THEMES="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/themes"

command -v jq >/dev/null 2>&1 || { echo "Error: jq is required" >&2; exit 1; }
[[ -d "$THEMES_DIR" ]] || { echo "Error: no themes/ beside this script" >&2; exit 1; }

# Theme names Alfred already knows about.
installed=""
if [[ -d "$ALFRED_THEMES" ]]; then
    installed=$(find "$ALFRED_THEMES" -name theme.json -exec jq -r '.alfredtheme.name' {} \; 2>/dev/null)
fi

imported=0
skipped=0

for f in "$THEMES_DIR"/*.alfredappearance; do
    [[ -e "$f" ]] || { echo "Error: no .alfredappearance files in $THEMES_DIR" >&2; exit 1; }

    name=$(jq -r '.alfredtheme.name' "$f" 2>/dev/null)
    if [[ -z "$name" || "$name" == "null" ]]; then
        echo "  skip    $(basename "$f") (unreadable, not valid theme JSON)"
        continue
    fi

    if grep -qxF "$name" <<<"$installed"; then
        echo "  skip    $name (already installed)"
        skipped=$((skipped + 1))
        continue
    fi

    echo "  import  $name"
    open "$f"

    # Alfred imports asynchronously and silently drops a file that arrives
    # while it is still busy with the previous one, so wait for this theme to
    # actually appear rather than guessing at a sleep. Observed latency is a
    # few seconds; 20 is generous headroom.
    landed=0
    for _ in $(seq 1 20); do
        sleep 1
        if [[ -d "$ALFRED_THEMES" ]] && find "$ALFRED_THEMES" -name theme.json \
             -exec jq -r '.alfredtheme.name' {} \; 2>/dev/null | grep -qxF "$name"; then
            landed=1
            break
        fi
    done

    if [[ $landed -eq 1 ]]; then
        imported=$((imported + 1))
    else
        echo "  WARN    $name did not appear - is Alfred running?" >&2
    fi
done

echo "Done: $imported imported, $skipped skipped."
[[ $imported -gt 0 ]] && echo "Select one in Alfred Preferences > Appearance."
exit 0
