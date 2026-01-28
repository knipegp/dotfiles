# AGENTS.md

## Build/Lint/Test Commands

- **Pre-commit**: `prek run` (runs all hooks on staged files)
- **Lint Nix**: `statix check` (checks for repeated keys, inherit patterns)
- **Shell scripts**: `shellcheck script.sh`
- **Test Home Manager build**: `home-manager build --flake ~/dotfiles/nixos/home-manager/` (builds without applying changes)
- **Apply Home Manager**: `home-manager switch -b backup --flake ~/dotfiles/nixos/home-manager/`
- **Test NixOS build**: `nixos-rebuild build --flake ~/dotfiles/nixos/#<hostname>` (builds without applying changes)
- **Apply NixOS**: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#<hostname>` (agents cannot run this command because it requires elevated privileges)

**IMPORTANT**: Always run build/test commands BEFORE applying changes to catch errors early.

**Note**: Home Manager now uses per-host configurations (griff@haleakala, griff@lahaina, etc.) to support host-specific settings.

## Code Style Guidelines

- **Naming**: Use snake_case for Nix attributes, camelCase for modules
- **Imports**: Group imports by type (system, user, files)
- **Formatting**: Use nixfmt-classic, 2-space indentation
- **Error handling**: Use `assert` for validation, `throw` for fatal errors
- **Patterns**: Prefer `inherit` over assignment, consolidate repeated keys
- **Modules**: Follow existing patterns in `modules/` directory
- **Comments**: Minimal comments, focus on clear attribute names

## Key Patterns

- Use triple flake structure (NixOS, Home Manager, Darwin separately)
- Modular design with shared system/user modules
- Configuration files managed via `home.file` in Home Manager
- Use the NixOS MCP server for information about NixOS options, packages, and flake configurations
