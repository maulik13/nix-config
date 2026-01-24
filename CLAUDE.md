# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Nix-based declarative system configuration** for macOS, using nix-darwin and home-manager to manage system and user environments. The configuration is titled "Diaballin dotfiles" and uses Nix Flakes for reproducible builds.

## Common Commands

### System Management
```bash
# Apply system configuration changes (most common command)
task update-osx

# Apply changes with unfree packages (when adding new proprietary software)
task update-osx-impure

# Update all flake inputs to latest versions
task update-pkgs

# Clean up old packages (older than 14 days)
task gc

# Manual darwin rebuild (if task runner unavailable)
nix run nix-darwin -- switch --flake .
```

### Development Workflow
1. Make changes to `.nix` files
2. Run `task update-osx` to apply changes
3. Changes to system configuration require logout/reboot to fully take effect
4. Changes to home-manager configuration (user packages/programs) apply immediately

## Architecture

### Configuration Layers

The system uses a **modular, three-layer architecture**:

1. **Host-Specific Layer** (`systems/macwork/`)
   - Machine-specific settings
   - Enables/disables system-wide services
   - Currently configured for: `mk-mac-work` (aarch64-darwin)

2. **Shared Layer** (`shared/`)
   - Common configuration across all potential hosts
   - `home.nix`: User environment, packages, program configurations
   - `host.nix`: Shared system settings
   - `darwin.nix`: macOS-specific defaults (Dock, Finder, keyboard)
   - `brew.nix`: Homebrew packages and casks

3. **Module Layer** (`programs/`, `darwin/`, `modules/`)
   - Reusable configuration modules
   - Each module follows NixOS options pattern with `enable` flag
   - Modules are auto-imported via `modules/home/default.nix`

### Key Design Patterns

**Custom Options Pattern**: Programs and services use a custom options namespace:
```nix
# Program modules use: my.programs.*
my.programs.zsh.enable = true;

# Darwin service modules use: my.services.*
my.services.yabai.enable = true;
```

**Module Structure**: Each program/service module follows this pattern:
```nix
{
  options.my.programs.<name> = {
    enable = mkEnableOption "My <name> configuration";
  };

  config = mkIf cfg.enable {
    # actual configuration
  };
}
```

**Auto-Import**: The `modules/home/default.nix` automatically imports all files from `programs/` directory, so new modules just need to be added as `.nix` files.

### Directory Structure

```
flake.nix                    # Entry point - defines inputs/outputs
├── config/
│   ├── hosts.nix           # Host definitions (hostname, arch, user)
│   ├── users.nix           # User mapping
│   └── [app-configs]/      # Application config files (yabai, sketchybar, etc.)
├── systems/macwork/
│   ├── home.nix           # Machine-specific user config
│   └── host.nix           # Machine-specific system config
├── shared/
│   ├── home.nix           # Shared user environment (packages, programs)
│   ├── host.nix           # Shared system settings
│   ├── darwin.nix         # macOS system defaults
│   └── brew.nix           # Homebrew packages
├── programs/              # Home-manager program modules (auto-imported)
│   ├── zsh.nix
│   ├── git.nix
│   ├── tmux.nix
│   └── ...
├── darwin/                # Darwin service modules
│   ├── yabai.nix
│   ├── skhd.nix
│   ├── sketchybar.nix
│   └── borders.nix
└── modules/home/          # Additional reusable modules
```

## Adding New Configuration

### Adding a New Program
1. Create `programs/<name>.nix` with the custom options pattern
2. Enable in `shared/home.nix`: `my.programs.<name>.enable = true;`
3. Run `task update-osx`

### Adding a New Darwin Service
1. Create `darwin/<name>.nix` with the custom options pattern
2. Import in `darwin/default.nix`
3. Enable in `systems/macwork/host.nix`: `my.services.<name>.enable = true;`
4. Run `task update-osx`

### Adding Packages
- User packages: Add to `home.packages` in `shared/home.nix`
- Homebrew formulas/casks: Add to `shared/brew.nix`

## Important Configuration Details

### Flake Inputs
- `nixpkgs` (unstable): Primary package source
- `nixpkgs-stable`: For packages needing stability (Azure CLI, AWS CLI, kubelogin)
- `home-manager`: User environment management
- `nix-darwin`: macOS system management
- `catppuccin`: Theme framework (macchiato flavor)
- `nix-homebrew`: Declarative Homebrew with tap management

### Custom Overlays
- `zjstatus`: Status bar framework overlay
- `nur`: Nix User Repository overlay
- Overlays defined in `flake.nix` and applied to both stable and unstable pkgs

### macOS Services
The configuration includes custom macOS window management:
- **yabai**: Tiling window manager (BSP layout, external bar, scripting addition)
- **skhd**: Hotkey daemon for window management shortcuts
- **sketchybar**: Status bar with custom plugins and items
- **jankyborders**: Window border highlighting

### Shell Configuration
- Primary shell: zsh with oh-my-zsh
- Kubeswitch integration for Kubernetes context switching
- Custom functions loaded from `~/.config/diaball/fns.sh`
- Homebrew environment for Apple Silicon (`/opt/homebrew`)

## Troubleshooting

### Permission Issues
macOS accessibility permissions for yabai/skhd may need manual approval in System Settings. Check accessibility warnings:
```bash
defaults read com.apple.universalaccessAuthWarning
```

### Scripting Addition
yabai's scripting addition requires sudo access without password. This is configured but may need manual setup after major macOS updates.

### Unfree Packages
If builds fail due to unfree packages, use `task update-osx-impure` which sets `NIXPKGS_ALLOW_UNFREE=1`.

## Working with This Repository

### File Formats
- `.nix` files: Nix expression language
- Use `nixfmt-rfc-style` for formatting (included in packages)
- Shell scripts in `config/` use bash syntax

### Git Workflow
- Main branch: `main`
- GPG signing enabled in git configuration
- Typical workflow: edit → `task update-osx` → test → commit

### Testing Changes
- System changes: `task update-osx` (requires sudo password)
- Preview changes before applying: `nix flake check`
- Dry run: `nix build .#darwinConfigurations.mk-mac-work.system`

## Package Management Philosophy

This configuration uses **declarative package management**:
- All packages defined in Nix configuration (reproducible)
- Homebrew managed declaratively via nix-homebrew
- No imperative `brew install` or `nix-env -i` commands
- Changes to packages require editing `.nix` files and running `task update-osx`
