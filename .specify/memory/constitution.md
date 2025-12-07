<!--
SYNC IMPACT REPORT: Constitution v1.0.0
======================================
Version Change: NEW CONSTITUTION (baseline)
Ratification: 2025-12-06
Status: CREATED

This is the inaugural constitution establishing governance for the dotfiles project.

New Principles:
  - Modular Architecture
  - Declarative Configuration
  - Reproducible Builds
  - Code Quality & Linting
  - Documentation Clarity

New Sections:
  - Core Principles (5 principles)
  - Technical Standards
  - Development Workflow
  - Governance

Templates Requiring Updates:
  ✅ plan-template.md (Constitution Check section now informative)
  ✅ spec-template.md (No updates needed - specs are general)
  ✅ tasks-template.md (No updates needed - tasks are general)
  ⚠  AGENTS.md (Reference this constitution for authority on governance)

Follow-up TODOs:
  - None - all placeholders replaced with concrete values
-->

# Dotfiles Constitution

## Core Principles

### I. Modular Architecture

Every piece of system configuration must be organized as a reusable, independently composable module. Modules are the smallest deployable unit of configuration.

**Non-negotiable rules:**
- System modules in `nixos/modules/system/` are generic and reusable across hosts
- User modules in `nixos/modules/user/` serve both system and Home Manager contexts
- Modules MUST declare all their options and defaults explicitly
- No host-specific logic in modules; host configuration only in `nixos/hosts/<hostname>/`
- Configuration files managed via Home Manager's `home.file` rather than direct system files

**Rationale:** Modularity enables safe reuse, prevents configuration drift between hosts, and makes testing/refactoring straightforward.

### II. Declarative Configuration Over Imperative Scripts

All system and user configuration is expressed declaratively via NixOS, Home Manager, or nix-darwin flakes. Imperative scripts (bash) exist only for one-time setup tasks, not recurring state management.

**Non-negotiable rules:**
- System state MUST be reproducible from flake definitions + flake.lock
- Scripts in `.specify/scripts/` are utilities (not configuration authority)
- No manual `nixos-rebuild` invocations without reflecting changes in flake.nix
- Home Manager configuration is version-controlled in `nixos/home-manager/home.nix`

**Rationale:** Declarative configuration is auditable, reproducible, and version-controllable. It prevents configuration drift and makes system state predictable.

### III. Reproducible Builds & Locked Inputs

All flakes use locked inputs (`flake.lock`) to ensure bit-for-bit reproducibility. Flake updates are deliberate and tested before merging.

**Non-negotiable rules:**
- `flake.lock` is always committed to git
- `nix flake update` runs only on explicit feature branches, never on main
- `nix flake lock --update-input` for targeted updates only after validation
- Unstable packages are explicitly overlaid and documented in host configs
- System clock and timezone are canonical sources of truth (not guessed)

**Rationale:** Locked builds prevent surprise breakage. Explicit updates create clear audit trails.

### IV. Code Quality & Linting

All code adheres to established linting and formatting standards enforced by pre-commit hooks. Code that fails linting cannot be merged.

**Non-negotiable rules:**
- Nix files MUST pass `statix check` (repeated keys, inherit patterns)
- Shell scripts MUST pass `shellcheck`
- Markdown files MUST pass `markdownlint`
- Pre-commit hooks run via `prek run` before every commit
- Formatting: Use `nixfmt-classic` (2-space indentation for Nix)
- Naming: snake_case for Nix attributes, camelCase for module names

**Rationale:** Automated linting catches errors early, maintains consistency, and reduces code review friction.

### V. Documentation Clarity Over Comments

Configuration is self-documenting through clear attribute names and option descriptions. Comments are minimal and explain "why," not "what."

**Non-negotiable rules:**
- Attribute names MUST be self-explanatory (prefer `enable_ssh_server` over `ssh_on`)
- Module options MUST have descriptions
- Comments explain design trade-offs, not what the code does
- README.rst documents high-level architecture and deployment
- AGENTS.md captures development guidance and code patterns

**Rationale:** Self-documenting code is easier to maintain and scales better than comment-heavy approaches.

## Technical Standards

### Nix & NixOS

- **Framework**: Triple flake structure (NixOS system, Home Manager, nix-darwin) in separate directories
- **Version Strategy**: NixOS unstable with stable overlays where needed
- **Module Patterns**: Follow `modules/` directory conventions for new modules
- **Error Handling**: Use `assert` for validation, `throw` for fatal configuration errors
- **Naming Conventions**: Attributes in snake_case, modules in camelCase

### Flake Management

- **System config**: `nixos/flake.nix` defines system configurations (haleakala, lihue, lahaina)
- **User config**: `nixos/home-manager/` for standalone Home Manager deployments
- **macOS config**: `nixos/darwin/` for nix-darwin managed systems
- **Lockfiles**: All `flake.lock` files committed to git for reproducibility

### Host Configuration

Each host in `nixos/hosts/<hostname>/` imports relevant system and user modules. Host-specific overrides are documented and minimal.

**Supported Hosts:**
- `haleakala` - Desktop workstation (Linux/NixOS)
- `lihue` - Laptop with power management (Linux/NixOS)
- `lahaina` - Additional host (Linux/NixOS)
- `maui` - macOS host (Darwin, ARM64/Intel configurable)

## Development Workflow

### Pre-commit Checks

All staged files are validated before commit:

```bash
prek install    # One-time setup
prek run        # Before every commit
prek run --all-files  # Full repo check
```

### Code Quality Checks

Before submitting changes:

```bash
statix check              # Nix linting
nixfmt-classic **/*.nix   # Nix formatting
shellcheck script.sh      # Shell validation
markdownlint '**/*.md'    # Markdown linting
```

### Flake Validation

Before updating inputs:

```bash
nix flake check           # Syntax and evaluation check
nix flake show            # Verify outputs
nixos-rebuild test --flake .  # Dry-run before switch
```

### Testing & Deployment

**Local Testing:**
- `nixos-rebuild test --flake ~/dotfiles/nixos/#<hostname>` - temporary boot
- `nixos-rebuild switch --flake ~/dotfiles/nixos/#<hostname>` - apply permanently

**Remote Deployment:**
- Deploy via SSH with `nixos-rebuild switch --target-host user@host --use-remote-sudo`
- Prerequisites: SSH access, Nix installed, user sudo privileges

## Governance

### Constitution Authority

This constitution is the source of truth for project governance. When conflicts arise between this constitution and other guidance, the constitution prevails. AGENTS.md and README.rst provide supporting detail but do not override constitutional principles.

### Amendment Process

**Principles or Standards changes** require:
1. Clear rationale for the amendment (problem being solved)
2. Impact assessment (which modules/hosts affected)
3. Migration plan for existing configurations if breaking
4. Version bump per semantic versioning rules (see below)
5. Update to this constitution file
6. Synchronization with dependent templates (plan-template.md, etc.)

**Versioning Rules:**
- MAJOR: Backward-incompatible principle changes, module removals, or breaking flake structure changes
- MINOR: New principle, new section, or material expansion of existing guidance
- PATCH: Clarifications, wording fixes, typo corrections, no semantic change

### Compliance Review

All pull requests MUST verify compliance:
- Do changes respect the five core principles?
- Do Nix files pass linting?
- Are flake changes locked and tested?
- Is new documentation/guidance clear and minimal?

### Templates Alignment

Templates in `.specify/templates/` (plan-template.md, spec-template.md, tasks-template.md) provide scaffolding for feature work. They MUST remain consistent with constitutional principles but are not authoritative; the constitution is. Template updates do not change the constitution.

### Authority & Review

- Constitution amendments are documented in git commit messages with rationale
- Current custodian: Project owner (griff)
- Future amendments should follow the Amendment Process above

**Version**: 1.0.0 | **Ratified**: 2025-12-06 | **Last Amended**: 2025-12-06
