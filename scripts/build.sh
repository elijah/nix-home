#!/usr/bin/env bash

# Build script for nix-home configuration
# Handles unfree packages like VS Code extensions

set -e

cd "$(dirname "$0")/.."

echo "Building nix-home configuration..."

# Build the configuration with unfree packages allowed
NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.elw.system --impure

echo "Build completed successfully!"
echo ""
echo "To apply the configuration, run:"
echo "  sudo darwin-rebuild switch --flake ."
echo ""
echo "Or use the update script:"
echo "  ./scripts/update.sh"
