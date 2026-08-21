# SketchyBar Color System

Two palettes — `colors/catppuccin.sh` and `colors/rosepine.sh`. The intent is
that both define the same variable names, so switching is just a matter of
sourcing a different file; in practice they have diverged badly (see Known
gaps). On top of the raw
palette each file also defines a **semantic layer** (`CONTEXT_APP`,
`INFO_PRIMARY`, `STATUS_ERROR`, `SECTION_BG`, …) so items can express intent
rather than naming a color, and each theme can map that intent to whichever of
its own colors suits.

## Theme switching

The choice lives in a mutable state file:

```
${XDG_STATE_HOME:-~/.local/state}/sketchybar/theme    # holds a bare name, e.g. "rosepine"
```

`sketchybarrc` and `common.sh` source `theme.sh`, which reads that file and
sources the matching palette. `theme-switch.sh` writes it and reloads the bar.

It has to work this way: everything under `~/.config/sketchybar` is a read-only
symlink into `/nix/store` — the derivation in `programs/sketchybar.nix` ends
with `chmod -R a-w` — so the config cannot rewrite itself. An earlier version
of `theme-switch.sh` tried to `sed -i` the `source` line in `sketchybarrc` and
`common.sh`; `sed` exits 1 on a store symlink, the script never checked, and
the bar silently kept whatever palette it was built with.

`theme.sh` falls back to catppuccin when the state file is missing, empty,
holds anything that is not a bare `[A-Za-z0-9_-]+` name, or names a palette
that no longer exists. A bad write should dull the colors, never stop the bar
from starting.

`theme-switch.sh` also switches Alfred, which keeps its own imported theme list
— see `config/alfred/import-themes.sh`.

## Usage

```bash
./theme-switch.sh rosepine      # switch
./theme-switch.sh               # defaults to catppuccin
./theme-switch.sh bogus         # invalid name lists what is available
```

Changes to the config tree need `task update-osx` before they reach
`~/.config`; the state file itself takes effect on the next bar reload.

## Adding a theme

Copy an existing `colors/*.sh`, keep **every** variable name it defines, and
remap the values. `theme-switch.sh` picks it up automatically — it validates
against `colors/<name>.sh`.

## Known gaps

These are real and currently affect the bar.

- **`NAV_PRIMARY` and `NAV_ACCENT` are undefined in both palettes** but used by
  `SPACE_COLORS` in `common.sh:19`. The array is unquoted, so the two empty
  expansions vanish and it collapses to 7 elements instead of 9 — every space
  past the first takes the wrong color. Affects catppuccin today, not just
  rosepine. Fix by defining both in each palette.

- **`rosepine.sh` is an incomplete port.** Items and plugins make 25 references
  to 11 Catppuccin-only names (`$YELLOW`, `$PEACH`, `$TEAL`, `$SAPPHIRE`,
  `$RED`, `$MAUVE`, `$GREEN`, `$PINK`, `$MAROON`, `$GREY`, `$BLUE`) that
  rosepine does not define — it has LOVE/GOLD/ROSE/PINE/FOAM/IRIS instead. All
  25 expand empty under rosepine. This went unnoticed because switching never
  worked, so rosepine was never loaded.

- **`rosepine.sh:78-79`** (`SPACE_BG_COLOR`, `SPACE_BORDER_COLOR`) call
  `ch_transp "$MAUVE"`, which throws an arithmetic error on load. Nothing
  consumes either variable, so this is log noise rather than a rendering bug.

- **Semantic migration is barely started.** Only 3 semantic names appear across
  all items and plugins; the rest still reference raw palette colors, which is
  what makes the gap above bite.
