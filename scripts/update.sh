#!/usr/bin/env bash
set -euo pipefail

# Update script for nix-home configuration
# This script handles updating flakes, rebuilding, and cleanup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

main() {
    cd "$REPO_DIR"
    
    log "Starting nix-home update process..."
    
    # Update flake lock
    log "Updating flake.lock..."
    nix flake update
    
    # Build new configuration
    log "Building new configuration..."
    NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.elw.system --impure
    
    # Switch to new configuration
    log "Switching to new configuration..."
    ./result/sw/bin/darwin-rebuild switch --flake .#elw
    
    # Optional: Push to cachix if configured
    if command -v cachix &> /dev/null && [ -n "${CACHIX_CACHE:-}" ]; then
        log "Pushing to cachix..."
        nix build .#darwinConfigurations.elw.system --json \
            | jq -r '.[].outputs | to_entries[].value' \
            | cachix push "$CACHIX_CACHE"
    fi
    
    # Cleanup old generations (keep last 5)
    log "Cleaning up old generations..."
    nix-collect-garbage --delete-older-than 30d
    
    log "Update complete!"
}

main "$@"
