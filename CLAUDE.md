# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using NixOS flakes for declarative system configuration management. The configuration supports multiple hosts (haleakala, lihue, lahaina) with both system-level and user-level configurations through NixOS and Home Manager.

## Key Commands

### NixOS System Configuration
```bash
# Apply system configuration for a specific host
sudo nixos-rebuild switch --flake /home/griff/dotfiles/nixos/#<hostname>

# Available hostnames: haleakala, lihue, lahaina
sudo nixos-rebuild switch --flake /home/griff/dotfiles/nixos/#lihue
```

### Home Manager Configuration
```bash
# Apply user configuration (run from nixos/home-manager directory)
cd /home/griff/dotfiles/nixos/home-manager
home-manager switch --flake .

# With backup and verbose output
home-manager -v switch -b backup --flake .
```

### Flake Management
```bash
# Update flake inputs
nix flake update

# Show flake info
nix flake show

# Check flake
nix flake check
```

### Pre-commit Hooks (prek)
This repository uses `prek` for pre-commit hooks. **Always run checks before committing changes.**

```bash
# Install pre-commit hooks (run once after cloning)
prek install

# Run all pre-commit checks on staged files
prek run

# Run all pre-commit checks on all files
prek run --all-files
```

The pre-commit hooks include:
- YAML validation
- Trailing whitespace and EOF fixes
- Large file detection
- Merge conflict detection
- Private key detection
- shellcheck for shell scripts
- statix for Nix linting (checks for repeated keys, inherit patterns, etc.)
- deadnix for unused Nix code detection

### Code Quality and Linting
```bash
# Run Nix code linter (statix is configured in statix.toml)
statix check

# Format Nix code
nixfmt-classic **/*.nix

# Check shell scripts (shellcheck is available)
shellcheck script.sh

# Format shell scripts
shfmt -w script.sh
```

#### Common statix warnings
- **W20 (Repeated keys)**: Consolidate repeated attribute keys into a single set (e.g., `services.foo = ...; services.bar = ...;` should become `services = { foo = ...; bar = ...; };`)
- **W04 (Assignment instead of inherit)**: Use `inherit (cfg) email;` instead of `email = cfg.email;`

## Architecture

### Directory Structure
- `nixos/` - Main NixOS configuration
  - `flake.nix` - System-level flake defining nixosConfigurations for each host
  - `hosts/` - Per-host system configurations
  - `modules/` - Reusable NixOS modules
  - `files/` - Dotfiles and configuration files
  - `home-manager/` - User-level configuration
    - `flake.nix` - Home Manager flake with user modules
    - `home.nix` - Base user configuration

### Configuration Pattern
The system uses a modular approach:

1. **System Level** (`nixos/flake.nix`): Defines nixosConfigurations for each host
2. **Host Configurations** (`nixos/hosts/*/configuration.nix`): Import system modules and hardware-specific settings
3. **User Level** (`nixos/home-manager/flake.nix`): Defines homeManagerConfiguration for user "griff"
4. **Modular Design**: Both system and user configurations use reusable modules:
   - System modules: `system_desktop.nix`, `system_development.nix`, `hyprland.nix`, etc.
   - User modules: `desktop-user.nix`, `development-user.nix`, `personal.nix`, etc.

### Key Modules
- `development.nix` - Development tools, Git config, terminal utilities, includes Python development
- `desktop.nix` - Desktop applications, window manager configs (Hyprland/Sway)
- `desktop-development.nix` - Combined desktop + development user setup
- `personal.nix` - Personal user configuration
- `gnupg.nix` - GPG configuration for signing commits
- `python-dev.nix` - Python-specific development tools
- `system/desktop.nix` - System-level desktop services
- `system/hyprland.nix` - Hyprland window manager configuration
- `system/development.nix` - System-level development tools

### Configuration Files Management
User dotfiles are managed through Home Manager's `home.file` attribute, linking files from `nixos/files/` to appropriate locations in `~/.config/`. Changes trigger automatic reloads where supported (e.g., Hyprland, Waybar).

## Host Setup Process

When adding a new host:
1. Create directory in `nixos/hosts/<hostname>/`
2. Copy `/etc/nixos/hardware-configuration.nix` to that directory
3. Create `configuration.nix` importing appropriate modules
4. Add host to `nixosConfigurations` in `nixos/flake.nix`

## Current Hosts
- **haleakala** - Desktop configuration
- **lihue** - Laptop with power management (TLP)
- **lahaina** - New host (recently added)

## Window Managers
Supports both Sway and Hyprland with shared configuration patterns. Hyprland is currently active with configs in `nixos/files/hyprland/`.

## Development Tools and Editor Configuration

### Emacs (Doom Emacs)
- Doom Emacs configuration in `nixos/files/doom/`
- Manual installation required (not managed by Nix)
- Emacsclient alias (`ec`) configured in bash
- PATH includes `~/.config/emacs/bin`

### Terminal and Shell Tools
The development environment includes modern CLI alternatives:
- `eza` (ls replacement)
- `ripgrep` (grep replacement)
- `bat` (cat replacement)
- `fd` (find replacement)
- `bottom` (htop replacement)
- `du-dust` (du replacement)
- `sd` (sed replacement)
- `procs` (ps replacement)

### Git Configuration
Git is configured with advanced settings including:
- GPG signing enabled by default
- Difftastic for better diffs
- Rebase-based workflow with auto-squash and auto-stash
- Histogram diff algorithm
- Conflict resolution with zdiff3

## Configuration Architecture Details

### Dual Flake Structure
The repository uses two separate flakes:
1. **System flake** (`nixos/flake.nix`): Manages nixosConfigurations for each host
2. **User flake** (`nixos/home-manager/flake.nix`): Manages homeManagerConfiguration for user "griff"

### Package Sources
Home Manager flake uses both stable and unstable nixpkgs:
- Main packages from `nixos-unstable`
- Stable packages available via `pkgs-stable` argument
