# Aider Agent Conventions

This file provides guidance to Aider agents when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using NixOS flakes for declarative system configuration management. The configuration supports multiple hosts across Linux and macOS with system-level and user-level configurations through NixOS, nix-darwin, and Home Manager.

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
```

### Home Manager Configuration
```bash
# Apply user configuration
cd /home/griff/dotfiles/nixos/home-manager
home-manager switch --flake .
```

### macOS (Darwin) Configuration
```bash
# Apply nix-darwin configuration
cd /home/griff/dotfiles/nixos/darwin
darwin-rebuild switch --flake .
```

### Flake Management
```bash
# Update flake inputs
nix flake update

# Show flake info
nix flake show
```

## Code Quality and Linting

### Pre-commit Hooks
This repository uses `prek` for pre-commit hooks. Always run checks before committing changes.

```bash
# Install pre-commit hooks
prek install

# Run all pre-commit checks on staged files
prek run

# Run all pre-commit checks on all files
prek run --all-files
```

### Linting Commands
```bash
# Run Nix code linter
statix check

# Format Nix code
nixfmt-classic **/*.nix

# Check shell scripts
shellcheck script.sh

# Lint Markdown files
markdownlint '**/*.md'
```

## Architecture

### Directory Structure
- `nixos/` - Main configuration directory
  - `flake.nix` - System-level flake defining nixosConfigurations for Linux hosts
  - `hosts/` - Per-host system configurations (haleakala, lihue, lahaina)
  - `modules/` - Reusable NixOS and user modules
  - `files/` - Dotfiles and configuration files
  - `home-manager/` - Standalone user-level configuration
  - `darwin/` - macOS configuration

### Configuration Pattern
The system uses a modular approach with three separate flakes:
1. **NixOS System Level** (`nixos/flake.nix`)
2. **Home Manager User Level** (`nixos/home-manager/flake.nix`)
3. **Darwin/macOS Level** (`nixos/darwin/flake.nix`)

## Current Hosts

### Linux (NixOS)
- **haleakala** - Desktop workstation
- **lihue** - Laptop with SSH server configuration
- **lahaina** - Laptop

### macOS (Darwin)
- **maui** - macOS host

## Development Tools
The development environment includes modern CLI alternatives and comprehensive tooling for development work.

## Important Notes for Aider Agents
- Always use Nix best practices when modifying Nix code
- Follow the existing modular architecture pattern
- Test changes with appropriate commands before suggesting them
- Be aware of the triple flake structure
- Consider both Linux and macOS compatibility when relevant
