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
│   └── ...
│
├── scripts/                # Utility scripts
│   ├── build.sh           # Build configuration
│   ├── validate-config.sh # Validation script
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

### System (`modules/system/`)
Core system configuration and services:
- **configuration.nix**: Base nix-darwin configuration
- **homebrew.nix**: Homebrew package management
- **security.nix**: Security and privacy tools
- **performance.nix**: Performance monitoring
- **backup-sync.nix**: Backup and synchronization
- **network-tools.nix**: Network utilities

### Development (`modules/development/`)
Programming languages, tools, and development environments:
- **development.nix**: Multi-language development setup
- **sysadmin.nix**: System administration and DevOps tools
- **data-science.nix**: Data science and analytics tools
- **ai-tooling.nix**: AI development tools
- **mcp-dev.nix**: Model Context Protocol development

### Applications (`modules/applications/`)
Desktop applications and user software:
- **emacs.nix**: Emacs editor with org-roam
- **vscode-extensions.nix**: VS Code extensions
- **knowledge-management.nix**: Note-taking and knowledge tools
- **productivity.nix**: Productivity applications
- **design-media.nix**: Design and media tools
- **cloud-networking.nix**: Cloud platform tools

### Workflows (`modules/workflows/`)
Automation and workflow enhancement:
- **alfred.nix**: Alfred app and workflows
- **ai-workflows.nix**: AI-powered automation
- **shell-enhancements.nix**: Enhanced shell configuration
- **org-roam-dendron.nix**: Knowledge management workflows

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
