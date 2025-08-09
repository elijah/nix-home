# Nix-Darwin Management

This directory contains tools for managing your nix-darwin configuration.

## Quick Start

```bash
# Deploy the configuration
./scripts/manage.sh deploy

# Test configuration without deploying
./scripts/manage.sh build

# Check configuration health
./scripts/manage.sh health

# Update dependencies
./scripts/manage.sh update
```

## Available Commands

- **`deploy`** - Deploy the nix-darwin configuration
- **`build`** - Test build without applying changes
- **`check`** - Run syntax and format validation
- **`update`** - Update all flake inputs
- **`health`** - System health diagnostics
- **`rollback`** - Rollback to previous generation
- **`help`** - Show detailed help

## Configuration Profiles

- **`minimal`** - Basic development setup
- **`elw`** - Main configuration with all features
- **`full`** - Complete feature set with all modules

## Key Features

✅ **Modular Architecture** - Easy to customize and extend
✅ **Multiple Profiles** - Different configurations for different needs  
✅ **Package Management** - Comprehensive tool selection
✅ **Environment Setup** - Optimized shell and development environment
✅ **Knowledge Management** - Obsidian, org-roam, note-taking tools
✅ **Development Tools** - VS Code, Emacs, language servers
✅ **System Optimization** - Performance monitoring and tuning

## Troubleshooting

If you encounter issues:

1. Run health check: `./scripts/manage.sh health`
2. Validate configuration: `./scripts/manage.sh check`  
3. Check build status: `./scripts/manage.sh build`
4. View logs in `/var/log/darwin-build.log`

## Updates

To update your configuration:

```bash
# Update dependencies
./scripts/manage.sh update

# Test the updated configuration
./scripts/manage.sh build

# Deploy if tests pass
./scripts/manage.sh deploy
```
