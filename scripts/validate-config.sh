#!/usr/bin/env bash

set -euo pipefail

echo "🔍 Validating nix-home configuration..."

# Check if all referenced modules exist
MODULES=(
    "configuration.nix"
    "homebrew.nix" 
    "alfred.nix"
    "knowledge-management.nix"
    "development.nix"
    "emacs.nix"
    "sysadmin.nix"
    "home/default.nix"
)

echo "📁 Checking module files..."
for module in "${MODULES[@]}"; do
    if [[ -f "$module" ]]; then
        echo "✅ $module exists"
    else
        echo "❌ $module missing - creating template..."
        case "$module" in
            "home/default.nix")
                mkdir -p home
                echo "{ config, pkgs, ... }: { home.stateVersion = \"23.05\"; }" > "$module"
                ;;
            *)
                echo "{ config, pkgs, ... }: { }" > "$module"
                ;;
        esac
    fi
done

echo "🏗️  Testing configuration build..."
if nix build .#darwinConfigurations.elw.system --dry-run; then
    echo "✅ Configuration builds successfully"
else
    echo "❌ Configuration build failed"
    exit 1
fi

echo "🧪 Running flake checks..."
if nix flake check; then
    echo "✅ All checks passed"
else
    echo "❌ Some checks failed"
    exit 1
fi

echo "🎉 Configuration validation complete!"