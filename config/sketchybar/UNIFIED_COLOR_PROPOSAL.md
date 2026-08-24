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
remap the values. `theme-switch.sh` picks it up automatically - it validates
against `colors/<name>.sh`.

Only the semantic names are contracts. Each palette's raw colors are private to
it: catppuccin has `MAUVE`/`BLUE`/`PEACH`, rose-pine has `IRIS`/`FOAM`/`GOLD`,
and neither set appears outside `colors/`. Items and plugins reference semantic
names only, so a new theme cannot silently leave one undefined.

To check a palette is complete, source it and confirm every name the items use
resolves:

```bash
grep -rhoE '\$\{?[A-Z][A-Z0-9_]+\}?' items plugins \
      ../sketchybar-wm/*/items ../sketchybar-wm/*/plugins \
  | tr -d '${}' | sort -u > /tmp/refs
grep -hoE '^export [A-Z0-9_]+=' colors/*.sh | sed 's/^export //; s/=$//' | sort -u > /tmp/names
comm -12 /tmp/refs /tmp/names   # every one of these must be set in both palettes
```

## Semantic vocabulary

Beyond the section groups (`NAV_*`, `CONTEXT_*`, `INFO_*`, `PROD_*`) and
`STATUS_*`, there is a **`GAUGE_*`** scale for continuous level readouts:
`GAUGE_FULL`, `GAUGE_HIGH`, `GAUGE_MID`, `GAUGE_LOW`, `GAUGE_CRITICAL`. Battery
charge and volume loudness both use it, so anything showing "how much" reads
the same way across the bar.

## History

Every gap this document used to list is now closed:

- `NAV_PRIMARY` / `NAV_ACCENT` were referenced by `SPACE_COLORS` but defined in
  neither palette. The array is unquoted, so the empty expansions vanished and
  it silently held 7 entries instead of 9 - every space past the first took the
  wrong color, under catppuccin as much as rose-pine. Both are now defined.

- `rosepine.sh` was an incomplete port: items made 25 references to 11
  Catppuccin-only names it did not define. All 25 now use semantic names.

- `rosepine.sh` computed `SPACE_BG_COLOR` / `SPACE_BORDER_COLOR` from `$MAUVE`,
  a Catppuccin name, which threw an arithmetic error on every load. They use
  `$NAV_PRIMARY` now.

- The semantic migration is complete for items and plugins; nothing outside
  `colors/` names a raw palette color.

Three colors deliberately changed when the migration landed, all under
catppuccin: volume 60-79% peach to yellow and volume 1-59% mauve to sapphire,
both from adopting the shared `GAUGE_*` scale; and the os-icon logo yellow to
mauve, which is what this document always specified for `NAV_PRIMARY`.
