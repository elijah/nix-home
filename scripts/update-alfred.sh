#!/bin/bash

# Quick sync script for Alfred workflows
# This script syncs your current Alfred workflows and commits them

cd "$(dirname "$0")/.."

echo "🔄 Syncing Alfred workflows..."
./scripts/sync-alfred-workflows.sh

echo
echo "📊 Checking for changes..."
if git diff --quiet assets/alfred-workflows/; then
    echo "✅ No changes detected - workflows are up to date"
else
    echo "📝 Changes detected, committing..."
    git add assets/alfred-workflows/
    git commit -m "Update Alfred workflows (auto-sync $(date +"%Y-%m-%d"))"
    echo "✅ Workflows synced and committed"
fi

echo
echo "🚀 Ready to rebuild system configuration"
echo "Run: darwin-rebuild switch --flake .#elw"
