#!/usr/bin/env bash

set -euo pipefail

FILTERED_WARNING='Using `lib.generators.toPlist` without `escape = true` is deprecated'

echo "🔍 Validating nix-home configuration..."

# Check if all referenced modules exist (canonical paths from flake.nix)
MODULES=(
    "modules/system/configuration.nix"
    "modules/system/homebrew.nix"
    "modules/development/development.nix"
    "modules/development/sysadmin.nix"
    "modules/applications/emacs.nix"
    "modules/applications/knowledge-management.nix"
    "modules/workflows/alfred.nix"
    "home/default.nix"
)

echo "📁 Checking module files..."
missing=0
for module in "${MODULES[@]}"; do
    if [[ -f "$module" ]]; then
        echo "✅ $module exists"
    else
        echo "❌ $module missing"
        missing=1
    fi
done

if [[ "$missing" -ne 0 ]]; then
    echo "❌ Validation aborted: one or more required modules are missing"
    exit 1
fi

echo "🏗️  Testing configuration build..."
if NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.elw.system --dry-run --impure --no-update-lock-file \
    2> >(grep -Fv "$FILTERED_WARNING" >&2); then
    echo "✅ Configuration builds successfully"
else
    echo "❌ Configuration build failed"
    exit 1
fi

echo "🧪 Running flake checks..."
if NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure --no-update-lock-file \
    2> >(grep -Fv "$FILTERED_WARNING" >&2); then
    echo "✅ All checks passed"
else
    echo "❌ Some checks failed"
    exit 1
fi

echo "🎉 Configuration validation complete!"