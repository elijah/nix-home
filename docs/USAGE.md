# Usage Guide

This guide explains how to use the reorganized nix-home configuration.

## Quick Start

### Apply Main Configuration
```bash
# Build and apply the main configuration
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#elw --impure
```

### Apply Alternative Configurations
```bash
# Minimal setup (just development tools)
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#minimal --impure

# Full setup (all modules enabled)
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#full --impure
```

## Working with Modules

### Enable a New Module

1. Add the module to your configuration in `flake.nix`:
```nix
modules.applications.productivity  # Enable productivity apps
```

2. Rebuild your configuration:
```bash
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#elw --impure
```

### Create a New Module

1. Use the module template:
```bash
nix flake init --template .#module
```

2. Move the created module to the appropriate directory:
```bash
mv default.nix modules/applications/my-new-module.nix
```

3. Add it to `modules/default.nix`

4. Import it in your configuration

### Testing and Validation

```bash
# Validate all configurations
nix flake check --impure

# Test build without applying
nix build .#darwinConfigurations.elw.system --impure

# Format all Nix files
nix fmt
```

## Development Workflow

### Development Shell
```bash
# Enter development environment
nix develop

# Or the specialized module development shell
nix develop .#modules
```

### Exploring Dependencies
```bash
# Visualize dependency tree
nix-tree .#darwinConfigurations.elw.system

# Compare configurations
nix-diff .#darwinConfigurations.minimal.system .#darwinConfigurations.full.system
```

## Common Tasks

### Adding a New Package
1. Find the appropriate module in `modules/`
2. Add the package to `environment.systemPackages`
3. Test with `nix flake check`
4. Apply with `darwin-rebuild switch`

### Debugging Issues
```bash
# Check build logs
nix log /nix/store/path-to-failed-derivation

# Verbose rebuild
sudo darwin-rebuild switch --flake .#elw --show-trace --verbose
```

### Managing Homebrew Packages
Edit `modules/system/homebrew.nix` or the main `Brewfile`

### VS Code Extensions
Edit `modules/applications/vscode-extensions.nix`

## Environment Variables

The configuration automatically sets:
- `NIXPKGS_ALLOW_UNFREE=1` - Allows unfree packages
- Development environment variables (GOPATH, etc.)
- Tool-specific configurations

## Profiles

Use pre-configured profiles for specific use cases:

```bash
# In flake.nix, uncomment desired profiles:
profiles.devops    # DevOps tools and workflows
profiles.ttrpg     # TTRPG and gaming tools
profiles.creative  # Creative and design tools
profiles.ai        # AI development tools
```

## Troubleshooting

### Common Issues

1. **Unfree package errors**: Ensure `NIXPKGS_ALLOW_UNFREE=1` is set
2. **Build failures**: Check `nix flake check` for validation errors
3. **Module conflicts**: Review enabled modules for conflicting packages
4. **Homebrew failures**: Check Brewfile for discontinued packages

### Getting Help

1. Check the documentation in `docs/`
2. Validate configuration with `nix flake check`
3. Review logs with `nix log`
4. Use `nix develop` for debugging environment
