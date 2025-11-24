###################
 G's System Config
###################

Personal system configuration using NixOS flakes for declarative and
reproducible system management across Linux and macOS.

**********
 Features
**********

-  **Multi-platform support**: NixOS (Linux) and nix-darwin (macOS)
-  **Modular architecture**: 32 reusable modules (24 system + 8 user)
-  **Triple flake structure**: Separate flakes for system, user, and
   Darwin configurations
-  **Remote deployment**: Deploy configurations to other machines via
   SSH
-  **Modern development environment**: Comprehensive tooling for
   development work
-  **Window managers**: Hyprland and Sway with shared configurations
-  **Reproducible builds**: Flake lockfile ensures consistent
   environments

*****************
 Supported Hosts
*****************

**Linux (NixOS)**

-  ``haleakala`` - Desktop workstation
-  ``lihue`` - Laptop with power management and SSH server
-  ``lahaina`` - Additional host

**macOS (Darwin)**

-  ``maui`` - macOS host (Apple Silicon/ARM64, configurable for Intel)

*************
 Quick Start
*************

Local Deployment
================

**NixOS System Configuration**

.. code:: bash

   # Apply system configuration
   sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#<hostname>

   # Test before applying
   sudo nixos-rebuild test --flake ~/dotfiles/nixos/#<hostname>

**Home Manager Configuration**

.. code:: bash

   # Apply user configuration
   cd ~/dotfiles/nixos/home-manager
   home-manager switch --flake .

**macOS (Darwin) Configuration**

.. code:: bash

   # Apply nix-darwin configuration
   cd ~/dotfiles/nixos/darwin
   darwin-rebuild switch --flake .

Remote Deployment
=================

Deploy NixOS configurations to remote hosts over SSH:

.. code:: bash

   # Deploy to remote host
   nixos-rebuild switch \
     --flake ~/dotfiles/nixos/#<hostname> \
     --target-host <user>@<host-or-ip> \
     --use-remote-sudo

**Prerequisites for remote deployment:**

-  SSH access with key-based authentication
-  Nix installed on target host
-  User with sudo privileges

**************************
 Boot-strapping New Hosts
**************************

Adding a New NixOS Host
=======================

#. Create directory structure:

   .. code:: bash

      mkdir -p nixos/hosts/<hostname>

#. Copy hardware configuration:

   .. code:: bash

      sudo cp /etc/nixos/hardware-configuration.nix nixos/hosts/<hostname>/

#. Create ``nixos/hosts/<hostname>/configuration.nix`` importing desired
   modules

#. Add host to ``nixosConfigurations`` in ``nixos/flake.nix``:

   .. code:: nix

      <hostname> = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/<hostname>/configuration.nix
        ];
      };

#. Test and apply:

   .. code:: bash

      sudo nixos-rebuild test --flake ~/dotfiles/nixos/#<hostname>
      sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#<hostname>

Adding a New macOS Host
=======================

#. Edit ``nixos/darwin/flake.nix`` and update:

   -  ``hostname`` variable
   -  ``system`` variable (``aarch64-darwin`` or ``x86_64-darwin``)

#. Customize ``nixos/darwin/configuration.nix`` as needed

#. Apply configuration:

   .. code:: bash

      cd nixos/darwin
      darwin-rebuild switch --flake .

******************
 Flake Management
******************

.. code:: bash

   # Update all flake inputs
   nix flake update

   # Show flake outputs
   nix flake show

   # Check flake for errors
   nix flake check

   # Update specific input
   nix flake lock --update-input nixpkgs

*******************
 Development Tools
*******************

This configuration includes:

-  **Modern CLI tools**: ``eza``, ``ripgrep``, ``bat``, ``fd``,
   ``bottom``
-  **Development environments**: Python, Nix, shell scripting
-  **Git configuration**: GPG signing, difftastic, rebase workflow
-  **Editor support**: Doom Emacs configuration (manual install
   required)
-  **Pre-commit hooks**: ``prek`` for automated quality checks

Pre-commit Hooks
================

This repository uses ``prek`` for pre-commit hooks. Always run checks
before committing:

.. code:: bash

   # Install hooks (once after cloning)
   prek install

   # Run checks on staged files
   prek run

   # Run checks on all files
   prek run --all-files

Code Quality
============

.. code:: bash

   # Lint Nix code
   statix check

   # Format Nix code
   nixfmt-classic **/*.nix

   # Check shell scripts
   shellcheck script.sh

   # Lint Markdown files
   markdownlint '**/*.md'

**************
 Architecture
**************

Directory Structure
===================

.. code::

   nixos/
   ├── flake.nix              # NixOS system configurations
   ├── hosts/                 # Per-host configurations
   │   ├── haleakala/
   │   ├── lihue/
   │   └── lahaina/
   ├── modules/               # Reusable modules
   │   ├── system/           # System-level modules (24)
   │   └── user/             # User-level modules (8)
   ├── files/                # Dotfiles and configs
   ├── home-manager/         # Standalone Home Manager
   │   ├── flake.nix
   │   └── home.nix
   └── darwin/               # macOS configurations
       ├── flake.nix
       ├── configuration.nix
       └── home.nix

Key Modules
===========

**System Modules** (``nixos/modules/system/``)

-  ``hyprland.nix`` - Hyprland window manager
-  ``ssh-server.nix`` - SSH server configuration
-  ``jellyfin.nix`` - Jellyfin media server
-  ``laptop-power.nix`` - Power management for laptops

**User Modules** (``nixos/modules/user/``)

-  ``development.nix`` - Development tools and Git config
-  ``desktop-development.nix`` - Combined desktop + development
-  ``personal.nix`` - Personal user configuration
-  ``gnupg.nix`` - GPG configuration for commit signing

Configuration Pattern
=====================

The repository uses three independent flakes:

#. **NixOS System** (``nixos/flake.nix``)

   -  Manages Linux system configurations
   -  Uses nixpkgs 25.05 with unstable overlay
   -  Defines configurations for haleakala, lihue, lahaina

#. **Home Manager** (``nixos/home-manager/flake.nix``)

   -  Standalone user configuration
   -  Can be used on any Linux system
   -  Supports both stable and unstable packages

#. **Darwin** (``nixos/darwin/flake.nix``)

   -  macOS system management via nix-darwin
   -  Integrates Home Manager for user config
   -  Supports Apple Silicon and Intel architectures

***************
 Documentation
***************

-  ``CLAUDE.md`` - Detailed guide for working with this repository
-  ``statix.toml`` - Nix linting configuration
-  ``.pre-commit-config.yaml`` - Pre-commit hook configuration

For more detailed information, see ``CLAUDE.md``.

*********
 License
*********

Personal dotfiles configuration. Use at your own discretion.
