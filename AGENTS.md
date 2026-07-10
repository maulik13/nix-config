# AGENTS.md

Instructions for Codex CLI and OpenAI coding agents working in this repository.

## Purpose and scope

This repository declaratively configures Apple Silicon Macs with Nix flakes, nix-darwin, Home Manager, and nix-homebrew. The configured hosts are `mk-mac-work` and `MKMBPM1P` (`aarch64-darwin`) for user `maulik`; both currently reuse the `systems/macwork` configuration and shared tooling.

## Configuration flow

- `flake.nix` is the entry point. It reads `config/hosts.nix` and creates one `darwinConfigurations` entry per host.
- `systems/macwork/` provides the common host-level nix-darwin and Home Manager configuration. `systems/macpersonal/` imports those modules and is the extension point for personal-machine-only settings.
- `shared/home.nix` owns common user packages and enables Home Manager program modules.
- `programs/` contains Home Manager modules under `my.programs.*`. New modules must be added to `programs/default.nix`.
- `darwin/` contains nix-darwin service modules under `my.services.*`. New modules must be added to `darwin/default.nix`.
- `config/` holds source configuration copied or linked into the user's home, plus shell scripts used by yabai and sketchybar.
- `flake.lock` pins all upstream inputs. Change it only when intentionally updating inputs.

## Change conventions

- Keep system-wide settings in `shared/host.nix`, macOS defaults in `shared/darwin.nix`, and Homebrew formulae/casks in `shared/brew.nix`.
- Put user CLI packages in `home.packages` in `shared/home.nix`. Prefer Nix packages; use Homebrew where macOS applications or unavailable packages require it.
- Put machine-specific overrides in `systems/macwork/`.
- Follow the existing option pattern: define an `enable` option below `my.programs.<name>` or `my.services.<name>`, then guard configuration with `lib.mkIf cfg.enable`.
- Reuse `pkgs-stable` only where the repository deliberately favors the stable channel; otherwise use `pkgs` from unstable.
- Use repository-relative paths in Nix expressions. Never hard-code another user or home directory; this repository currently expects `/Users/maulik`.
- Format Nix changes with `nixfmt`. Preserve the style of shell and KDL files near the code being changed.
- Manage packages declaratively. Do not run `brew install`, `nix-env -i`, or manually edit generated Home Manager files.
- Do not place secrets, work credentials, tokens, or machine-local private material in the repository.

## Validation

Start with non-mutating checks and report anything that could not run:

```sh
nixfmt --check <changed-nix-files>
nix flake check
nix build .#darwinConfigurations.<hostname>.system
```

The build can be slow and may need network access when inputs are not cached. Shell scripts should additionally be checked with `bash -n <file>` where applicable.

Applying a configuration mutates the live work machine and may prompt for sudo. Do it only when explicitly requested:

```sh
task update-osx
# On the personal Mac (MKMBPM1P):
task update-osx-personal
```

For an explicitly requested impure rebuild, use `task update-osx-impure`. Update all pinned inputs only when requested with `task update-pkgs`; do not casually rewrite `flake.lock`. Garbage collection (`task gc`) is destructive cleanup and is not part of normal validation.

## macOS caveats

- yabai, skhd, SketchyBar, and JankyBorders are coordinated across `darwin/`, `programs/`, and `config/`; inspect all relevant layers before changing window-management behavior.
- yabai/skhd can require Accessibility permissions, and yabai scripting additions may require manual setup again after macOS upgrades.
- Some nix-darwin changes need logout or reboot; Home Manager-only changes usually take effect during the switch.
- Home Manager uses backup extension `.bu`. Avoid creating competing files at paths already owned through `xdg.configFile` or `home.file`.

## Working safely

Inspect `git status` before editing and preserve unrelated user changes. Prefer small, scoped diffs. In the final handoff, name the files changed, validation performed, and any manual activation, permission, logout, or reboot step still required.
