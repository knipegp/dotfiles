# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using NixOS flakes for declarative system configuration management. The configuration supports multiple hosts across Linux and macOS with system-level and user-level configurations through NixOS, nix-darwin, and Home Manager.

### Supported Hosts
- **Linux (NixOS)**: haleakala, lihue, lahaina
- **macOS (Darwin)**: maui

## Key Commands

### NixOS System Configuration
```bash
# Apply system configuration locally for a specific host
sudo nixos-rebuild switch --flake /home/griff/dotfiles/nixos/#<hostname>

# Examples
sudo nixos-rebuild switch --flake /home/griff/dotfiles/nixos/#lihue
sudo nixos-rebuild switch --flake /home/griff/dotfiles/nixos/#haleakala

# Remote deployment to another host
sudo nixos-rebuild switch \
  --flake /home/griff/dotfiles/nixos/#<hostname> \
  --target-host <user>@<host-or-ip> \
  --use-remote-sudo

# Example: Deploy to lihue remotely
sudo nixos-rebuild switch \
  --flake ~/dotfiles/nixos/#lihue \
  --target-host admin@10.200.0.208 \
  --use-remote-sudo

# Test configuration before applying
sudo nixos-rebuild test --flake /home/griff/dotfiles/nixos/#<hostname>

# Build without switching
sudo nixos-rebuild build --flake /home/griff/dotfiles/nixos/#<hostname>
```

### Home Manager Configuration
```bash
# Apply user configuration (run from nixos/home-manager directory)
cd /home/griff/dotfiles/nixos/home-manager
home-manager switch --flake .

# With backup and verbose output
home-manager -v switch -b backup --flake .
```

### macOS (Darwin) Configuration
```bash
# Apply nix-darwin configuration (run from nixos/darwin directory)
cd /home/griff/dotfiles/nixos/darwin
darwin-rebuild switch --flake .

# Or specify the hostname explicitly
darwin-rebuild switch --flake .#maui

# Build without switching
darwin-rebuild build --flake .
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
- `nixos/` - Main configuration directory
  - `flake.nix` - System-level flake defining nixosConfigurations for Linux hosts
  - `hosts/` - Per-host system configurations (haleakala, lihue, lahaina)
  - `modules/` - Reusable NixOS and user modules
    - `system/` - System-level modules (24 modules)
    - `user/` - User-level modules (8 modules)
  - `files/` - Dotfiles and configuration files
  - `home-manager/` - Standalone user-level configuration
    - `flake.nix` - Home Manager flake with user modules
    - `home.nix` - Base user configuration
  - `darwin/` - macOS configuration
    - `flake.nix` - nix-darwin flake for macOS hosts
    - `configuration.nix` - macOS system configuration
    - `home.nix` - macOS user configuration

### Configuration Pattern
The system uses a modular approach with three separate flakes:

1. **NixOS System Level** (`nixos/flake.nix`):
   - Defines nixosConfigurations for Linux hosts (haleakala, lihue, lahaina)
   - Uses nixpkgs 25.05 with unstable overlay
   - Imports host-specific configurations from `hosts/*/configuration.nix`

2. **Home Manager User Level** (`nixos/home-manager/flake.nix`):
   - Defines standalone homeManagerConfiguration for user "griff"
   - Uses both stable and unstable nixpkgs
   - Can be used independently on any Linux system

3. **Darwin/macOS Level** (`nixos/darwin/flake.nix`):
   - Defines darwinConfiguration for macOS hosts (maui)
   - Integrates Home Manager for user configuration
   - Supports both Apple Silicon (aarch64) and Intel (x86_64)

4. **Modular Design**: All configurations share reusable modules:
   - System modules (24): `ssh-server.nix`, `hyprland.nix`, `jellyfin.nix`, etc.
   - User modules (8): `development.nix`, `desktop-development.nix`, `personal.nix`, etc.

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

### Adding a New Linux Host
When adding a new NixOS host:
1. Create directory in `nixos/hosts/<hostname>/`
2. Copy `/etc/nixos/hardware-configuration.nix` to that directory
3. Create `configuration.nix` importing appropriate modules
4. Add host to `nixosConfigurations` in `nixos/flake.nix`
5. Test the configuration: `nixos-rebuild test --flake .#<hostname>`

### Adding a New macOS Host
When adding a new Darwin host:
1. Update `hostname` variable in `nixos/darwin/flake.nix`
2. Adjust `system` variable for architecture (aarch64-darwin or x86_64-darwin)
3. Customize `darwin/configuration.nix` as needed
4. Run: `darwin-rebuild switch --flake .#<hostname>`

## Remote Deployment

### Prerequisites for Remote Deployment
- SSH access to the target host
- Nix installed on the target host
- User with sudo privileges (use `--use-remote-sudo`)
- SSH key-based authentication configured

### Remote Deployment Commands
```bash
# Deploy to a remote Linux host
sudo nixos-rebuild switch \
  --flake ~/dotfiles/nixos/#<hostname> \
  --target-host <user>@<host-or-ip> \
  --use-remote-sudo

# Build remotely but don't activate
sudo nixos-rebuild build \
  --flake ~/dotfiles/nixos/#<hostname> \
  --target-host <user>@<host-or-ip>

# Test configuration remotely (doesn't persist across reboot)
sudo nixos-rebuild test \
  --flake ~/dotfiles/nixos/#<hostname> \
  --target-host <user>@<host-or-ip> \
  --use-remote-sudo
```

### Common Remote Deployment Scenarios
```bash
# Deploy lihue from another machine
sudo nixos-rebuild switch \
  --flake ~/dotfiles/nixos/#lihue \
  --target-host admin@10.200.0.208 \
  --use-remote-sudo

# Deploy using hostname instead of IP
sudo nixos-rebuild switch \
  --flake ~/dotfiles/nixos/#lihue \
  --target-host admin@lihue.local \
  --use-remote-sudo

# Build configuration locally, deploy remotely
nix build .#nixosConfigurations.lihue.config.system.build.toplevel
sudo nixos-rebuild switch \
  --flake ~/dotfiles/nixos/#lihue \
  --target-host admin@10.200.0.208 \
  --use-remote-sudo
```

## Current Hosts

### Linux (NixOS)
- **haleakala** - Desktop workstation
- **lihue** - Laptop with power management (TLP), SSH server configuration
- **lahaina** - Additional host

### macOS (Darwin)
- **maui** - macOS host (Apple Silicon/ARM64 by default, configurable for Intel)

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

### Triple Flake Structure
The repository uses three separate flakes for maximum flexibility:
1. **NixOS System flake** (`nixos/flake.nix`): Manages nixosConfigurations for Linux hosts
2. **Home Manager flake** (`nixos/home-manager/flake.nix`): Standalone user configuration for user "griff"
3. **Darwin flake** (`nixos/darwin/flake.nix`): Manages darwinConfiguration for macOS hosts with integrated Home Manager

### Package Sources
Home Manager flake uses both stable and unstable nixpkgs:
- Main packages from `nixos-unstable`
- Stable packages available via `pkgs-stable` argument
