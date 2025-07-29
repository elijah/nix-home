# Alfred Workflows

This directory contains custom Alfred workflows that are managed by the nix-home configuration.

## How It Works

The nix-darwin configuration includes an Alfred workflow activation system that:

1. Installs Alfred via nixpkgs
2. Provides a script to automatically install workflows from this directory
3. Runs the installation script on system rebuild via a LaunchAgent

## Adding Custom Workflows

1. Download `.alfredworkflow` files and place them in this directory
2. Rebuild your nix-darwin configuration: `darwin-rebuild switch --flake .#elw`
3. The workflows will be automatically installed to Alfred

## Available Utilities

The configuration provides these utility packages for workflow development:

- **unzip** - For extracting .alfredworkflow files
- **jq** - JSON processing for workflow scripts
- **curl** - HTTP requests for web-based workflows

## Manual Installation

If you need to manually trigger workflow installation:

```bash
alfred-activate-workflows
```

This script is available in your PATH after rebuilding the configuration.

## Workflow Development

To create custom workflows:

1. Develop your workflow in Alfred
2. Export it as a `.alfredworkflow` file
3. Place it in this directory
4. The workflow will be automatically installed on the next rebuild

## Configuration

See `alfred.nix` in the root directory for the current Alfred configuration and workflow management system.
