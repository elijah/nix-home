# Nix-Home Repository Structure

This document describes the organization and structure of the nix-home repository.

## Directory Structure

```
nix-home/
├── flake.nix                 # Main flake configuration
├── flake.lock               # Flake input lock file
│
├── modules/                 # Organized module configuration
│   ├── default.nix         # Module index/exports
│   ├── system/             # System-level configuration
│   │   ├── configuration.nix
│   │   ├── homebrew.nix
│   │   └── ...
│   ├── development/        # Development tools and environments
│   │   ├── development.nix
│   │   ├── sysadmin.nix
│   │   └── ...
│   ├── applications/       # Desktop applications and software
│   │   ├── emacs.nix
│   │   ├── vscode-extensions.nix
│   │   └── ...
│   └── workflows/          # Automation and workflow enhancements
│       ├── alfred.nix
│       ├── shell-enhancements.nix
│       └── ...
│
├── profiles/               # Pre-configured module combinations
│   ├── default.nix        # Default profile
│   ├── devops.nix         # DevOps-focused configuration
│   ├── ttrpg.nix          # TTRPG-focused configuration
│   ├── creative.nix       # Creative work configuration
│   └── ai.nix             # AI development configuration
│
├── home/                   # Home Manager configuration
│   ├── default.nix        # Main home configuration
│   ├── shells.nix         # Shell configuration
│   ├── linux/             # Standalone Ubuntu/WSL2 home-manager entry point
│   └── ...
│
├── lima/                   # Lima VM templates for the Linux test harness
│   └── ubuntu-2404-wsl-test.yaml
│
├── scripts/                # Utility scripts
│   ├── build.sh           # Build configuration
│   ├── validate-config.sh # Validation script
│   ├── linux-test-harness.sh # Lima-based Linux/WSL2 personality test harness
│   └── ...
│
├── templates/              # Templates for new modules/profiles
│   ├── module/            # Module template
│   └── profile/           # Profile template
│
├── docs/                   # Documentation
│   ├── ARCHITECTURE.md    # This file
│   ├── MODULE-GUIDE.md    # Guide for creating modules
│   └── USAGE.md           # Usage instructions
│
├── assets/                 # Static assets
│   ├── alfred-workflows/  # Alfred workflows
│   ├── dotfiles/         # Configuration files
│   └── scripts/          # Utility scripts
│
└── logs/                   # Build logs and output
```

## Module Categories

**Sharing model:** most modules below are plain **home-manager** modules
(using `home.packages`/`home.sessionVariables`/`home.shellAliases`/
`home.activation`) and are imported directly by both `home/default.nix`
(macOS) and `home/linux/default.nix` (Linux) - they are **not** wired into
`flake.nix`'s `darwinConfigurations` at all. Only modules that use genuinely
darwin-only options (`system.defaults`, `system.activationScripts`,
Homebrew, GUI `.app` bundles) are still imported directly into
`darwinConfigurations`. Each module below is marked *(shared)* or
*(darwin-only)* accordingly. See "Shared Module Strategy" below for the
rationale and conventions.

### System (`modules/system/`)
- **configuration.nix** *(darwin-only)*: `nix.conf`, `system.defaults`,
  `system.primaryUser`/`stateVersion` - not home-manager options.
- **homebrew.nix** *(darwin-only)*: Homebrew package management (Linux uses
  `modules/linux/packages.nix` instead).
- **performance.nix** *(darwin-only)*: Dock/Finder/trackpad/screencapture
  `system.defaults`. The cross-platform performance-monitoring packages/
  aliases that used to live here moved to
  `modules/development/performance-tools.nix` *(shared)*.
- **security.nix** *(shared)*: Security/privacy tools; `pinentry_mac` vs
  `pinentry-curses` gated by `lib.optionals pkgs.stdenv.isDarwin`/`isLinux`.
- **backup-sync.nix** *(shared)*: Backup and synchronization tools.
- **network-tools.nix** *(shared)*: Network utilities.

### Development (`modules/development/`)
All *(shared)*:
- **development.nix**: Multi-language development setup.
- **sysadmin.nix**: System administration and DevOps tools (already used
  `lib.optionals isLinux/isDarwin` package gating before this became a
  shared module - that pattern is now used throughout).
- **data-science.nix**: Data science and analytics tools (converted for
  parity, but currently commented out of `home/default.nix` /
  `home/linux/default.nix` due to nixpkgs cache substitution issues with
  this package set).
- **ai-tooling.nix**: AI development tools.
- **mcp-dev.nix**: Model Context Protocol / local LLM tooling (heavy:
  includes `python3Packages.torch`/`transformers` - see the disk-space note
  below if testing in a constrained VM).
- **performance-tools.nix**: Performance-monitoring packages/aliases split
  out of `system/performance.nix`.

### Applications (`modules/applications/`)
- **emacs.nix** *(darwin-only)*: GUI app, not installed on the Linux
  personality.
- **vscode-extensions.nix** *(darwin-only)*: GUI app, not installed on the
  Linux personality.
- **knowledge-management.nix** *(shared)*: Note-taking and knowledge tools
  (Obsidian/Logseq GUI apps work under WSL2 via WSLg).
- **productivity.nix** *(shared)*: Productivity CLI tools.
- **design-media.nix** *(shared)*: Design and media tools.
- **cloud-networking.nix** *(shared)*: Cloud platform tools (`insomnia` is
  gated off aarch64-linux - not packaged there in nixpkgs).

### Workflows (`modules/workflows/`)
- **alfred.nix** *(darwin-only)*: macOS Alfred app + LaunchAgents.
- **ai-workflows.nix** *(shared)*: AI-powered automation
  (`terminal-notifier` gated to Darwin).
- **shell-enhancements.nix** *(shared)*: Enhanced shell configuration
  (`$EDITOR`/`$VISUAL` default to `code --wait` on Darwin, `nvim` on Linux -
  no VS Code on the Linux personality).
- **org-roam-dendron.nix** *(shared)*: Knowledge management workflows.

### Linux (`modules/linux/`)
Package strategy for the standalone Ubuntu 24.04/WSL2 Home Manager
personality (not a nix-darwin module - see `docs/LINUX-WSL2.md`):
- **packages.nix**: apt-native / vendor-apt-repo / Homebrew(Linux)-fallback
  tiers, used only for packages that need genuine OS-level integration
  (Docker Engine's daemon + systemd unit, hardware-adjacent packages like
  `rtl-sdr`, tools with known nix build flakiness like Node.js on
  nix-darwin) or aren't available any other way (`awscli` - nixpkgs'
  `awscli2` is disabled repo-wide due to cache substitution failures).
  Everything else that's a plain cross-platform CLI tool (e.g. `gh`,
  `kubernetes-helm`, `mise`, `sops`) is installed via the shared
  home-manager modules above instead of apt/vendor-repo/Homebrew.

## Shared Module Strategy

To maximize code shared between the macOS (nix-darwin) and Linux (WSL2)
personalities while keeping darwin-only functionality cleanly separated:

1. **Prefer home-manager options over nix-darwin options** wherever a
   module is just "packages + env vars + directory setup":
   `environment.systemPackages` → `home.packages`,
   `environment.variables` → `home.sessionVariables`,
   `environment.shellAliases` → `home.shellAliases`,
   `system.activationScripts.<name>.text` →
   `home.activation.<name> = lib.hm.dag.entryAfter [ "writeBoundary" ] ...`
   (using the `run`/`verboseEcho` helper functions and
   `${config.home.homeDirectory}` instead of a hardcoded `/Users/elw` path -
   home-manager activation always runs as the target user, so no `chown` is
   needed, unlike root-run nix-darwin `system.activationScripts`).
2. **Gate platform-only entries inside a shared file** with
   `lib.optionals pkgs.stdenv.isDarwin`/`isLinux` (packages) or
   `lib.optionalAttrs` (shell aliases) - see `modules/system/security.nix`
   (pinentry) or `modules/development/sysadmin.nix` (monitoring tools) for
   examples.
3. **Watch for `home.sessionVariables`/`home.shellAliases` key collisions**
   once multiple previously-separate modules share the same option
   namespace - home-manager will raise a "conflicting definition values"
   eval error if two modules set the same key to different values. Prefer
   removing the duplicate (keeping whichever module actually owns/consumes
   the variable) over `lib.mkForce`, unless there's a genuine
   priority-ordering need.
4. **Watch for platform-unsupported packages**: a package available on
   `x86_64-linux` isn't guaranteed to be available on `aarch64-linux` (e.g.
   `insomnia` in `modules/applications/cloud-networking.nix`). The fast
   cross-platform checks (below) catch this automatically.
5. **Disk footprint**: the shared modules pull in some large packages (e.g.
   `python3Packages.torch`/`transformers` in `mcp-dev.nix`, LaTeX/PDF
   tooling, `python312Packages` data-science stacks). A real WSL2 install
   typically has plenty of disk, but small test VMs (including the default
   Lima harness disk size) may need to be sized up accordingly.

## Regression Testing Strategy

Two tiers of validation protect both personalities against upstream
nixpkgs changes:

1. **Fast, VM-less checks** (`nix flake check` / `scripts/manage.sh check`):
   - `module-syntax` / `home-manager-syntax`: `nix-instantiate --parse`
     every file under `modules/` and `home/`.
   - `config-builds` / `minimal-builds` / `full-builds`: dry-run-evaluate
     all three `darwinConfigurations`.
   - The Linux dry-run step in `scripts/manage.sh check` runs
     `nix build .#homeConfigurations.elw-linux(-aarch64).activationPackage
     --dry-run`, which evaluates the full derivation graph for both Linux
     architectures (catching eval errors, option conflicts, and
     platform-unsupported packages) without needing a builder for that
     platform. This isn't a `checks` derivation itself, since invoking `nix`
     recursively against the flake needs network/daemon access the Nix
     build sandbox blocks by default.
2. **Deep, VM-based validation** (`scripts/linux-test-harness.sh` /
   `scripts/manage.sh linux-test`): spins up a real Lima Ubuntu 24.04 VM,
   runs `home-manager switch --flake .#elw-linux` for real, then
   `linux-bootstrap` for the apt/vendor-repo/Homebrew tiers. Run this
   periodically (e.g. after `nix flake update`, or before relying on the
   Linux personality for something important) - it's slower but catches
   real build/activation failures the fast checks can't (missing runtime
   deps, apt bootstrap issues, disk space, etc). See `docs/LINUX-WSL2.md`.



## Configuration Profiles

The `profiles/` directory contains pre-configured combinations of modules for specific use cases:

- **devops.nix**: DevOps engineer setup
- **ttrpg.nix**: Tabletop RPG gamer setup
- **creative.nix**: Creative professional setup
- **ai.nix**: AI developer setup

## Available Configurations

The flake provides multiple darwin configurations:

- **elw**: Current personalized configuration
- **minimal**: Minimal development setup
- **full**: All modules enabled

It also provides a standalone Linux personality (not a darwin configuration)
for Ubuntu 24.04/WSL2 via `homeConfigurations`: **elw-linux** (`x86_64-linux`)
and **elw-linux-aarch64** (`aarch64-linux`). See `docs/LINUX-WSL2.md` for
details, including the Lima-based test harness for exercising it from macOS.

## Benefits of This Structure

1. **Modularity**: Easy to enable/disable specific functionality
2. **Maintainability**: Clear separation of concerns
3. **Reusability**: Modules can be shared and reused
4. **Testability**: Individual modules can be tested in isolation
5. **Documentation**: Clear organization makes the system self-documenting
6. **Extensibility**: Easy to add new modules or profiles

## Migration from Old Structure

To migrate from the old flat structure:

1. All `.nix` files moved to appropriate `modules/` subdirectories
2. `flake.nix` updated to use new module paths
3. Module imports updated to use the new structure
4. Validation scripts updated for new paths
