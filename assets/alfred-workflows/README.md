# Alfred Workflows

This directory contains Alfred workflows managed by the nix-home configuration.

## Current Workflows (Auto-synced 2025-07-29 12:39)

The following workflows were automatically exported from your Alfred installation:

- **Alfred-Workflow-Devtools**
- **Backup-Preferences**
- **GitFred**
- **GitHub-Star**
- **Hammerspoon-Workflow**
- **Network-Quality**
- **Network**
- **Owledge-All-your-tools-in-one-search**
- **Search-ALL-the-docs**
- **Shimmering-Obsidian**
- **System-Settings**

## How It Works

The nix-darwin configuration includes an Alfred workflow activation system that:

1. Installs Alfred via Homebrew
2. Provides utilities for workflow management (unzip, jq, curl)
3. Automatically installs workflows from this directory on system rebuild
4. Runs the installation script via a LaunchAgent

## Syncing Workflows

To sync your current Alfred workflows to this directory:

```bash
./scripts/sync-alfred-workflows.sh
```

## Adding New Workflows

1. Download `.alfredworkflow` files and place them in this directory
2. Rebuild your nix-darwin configuration: `darwin-rebuild switch --flake .#elw`
3. The workflows will be automatically installed to Alfred

## Manual Installation

If you need to manually trigger workflow installation:

```bash
alfred-activate-workflows
```

## Configuration

See `alfred.nix` in the root directory for the current Alfred configuration and workflow management system.
