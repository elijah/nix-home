#!/bin/bash

# Sync existing Alfred workflows to nix-home configuration
# This script exports your current Alfred workflows and copies them to the nix-home assets directory

set -e

ALFRED_WORKFLOWS_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows"
TARGET_DIR="$(cd "$(dirname "$0")/.." && pwd)/assets/alfred-workflows"
TEMP_DIR=$(mktemp -d)

echo "🚀 Syncing Alfred workflows to nix-home configuration..."
echo "Source: $ALFRED_WORKFLOWS_DIR"
echo "Target: $TARGET_DIR"
echo "Temp: $TEMP_DIR"
echo

# Check if Alfred workflows directory exists
if [ ! -d "$ALFRED_WORKFLOWS_DIR" ]; then
    echo "❌ Alfred workflows directory not found. Make sure Alfred is installed and configured."
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Remove example.md if it exists
[ -f "$TARGET_DIR/example.md" ] && rm "$TARGET_DIR/example.md"

# Counter for workflows processed
count=0
skipped=0

echo "📦 Processing workflows..."

# Process each workflow directory
for workflow_dir in "$ALFRED_WORKFLOWS_DIR"/user.workflow.*; do
    if [ ! -d "$workflow_dir" ]; then
        continue
    fi
    
    workflow_uuid=$(basename "$workflow_dir")
    info_plist="$workflow_dir/info.plist"
    
    if [ ! -f "$info_plist" ]; then
        echo "⚠️  Skipping $workflow_uuid (no info.plist)"
        ((skipped++))
        continue
    fi
    
    # Extract workflow information
    workflow_name=$(plutil -p "$info_plist" | grep '"name"' | sed 's/.*=> "\(.*\)"/\1/')
    workflow_bundleid=$(plutil -p "$info_plist" | grep '"bundleid"' | sed 's/.*=> "\(.*\)"/\1/')
    
    if [ -z "$workflow_name" ]; then
        echo "⚠️  Skipping $workflow_uuid (no name found)"
        ((skipped++))
        continue
    fi
    
    # Clean workflow name for filename
    clean_name=$(echo "$workflow_name" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    output_file="$TARGET_DIR/${clean_name}.alfredworkflow"
    
    echo "📋 Processing: $workflow_name"
    echo "   Bundle ID: $workflow_bundleid"
    echo "   UUID: $workflow_uuid"
    
    # Create .alfredworkflow file (it's just a zip)
    cd "$workflow_dir"
    zip -r "$output_file" . > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Exported to: $(basename "$output_file")"
        ((count++))
    else
        echo "   ❌ Failed to export"
        ((skipped++))
    fi
    echo
done

echo "📊 Summary:"
echo "   ✅ Successfully exported: $count workflows"
echo "   ⚠️  Skipped: $skipped workflows"
echo "   📁 Location: $TARGET_DIR"
echo

# Update the README with current workflows
cat > "$TARGET_DIR/README.md" << EOF
# Alfred Workflows

This directory contains Alfred workflows managed by the nix-home configuration.

## Current Workflows (Auto-synced $(date +"%Y-%m-%d %H:%M"))

The following workflows were automatically exported from your Alfred installation:

EOF

# List all .alfredworkflow files
for workflow_file in "$TARGET_DIR"/*.alfredworkflow; do
    if [ -f "$workflow_file" ]; then
        filename=$(basename "$workflow_file" .alfredworkflow)
        echo "- **$filename**" >> "$TARGET_DIR/README.md"
    fi
done

cat >> "$TARGET_DIR/README.md" << 'EOF'

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
EOF

echo "📝 Updated README.md with current workflow list"
echo
echo "🎉 Sync complete! Your Alfred workflows are now managed by nix-home."
echo
echo "Next steps:"
echo "1. Review the exported workflows in: $TARGET_DIR"
echo "2. Commit the changes: git add assets/alfred-workflows && git commit -m 'Sync Alfred workflows'"
echo "3. The workflows will be automatically installed on next system rebuild"

# Cleanup
rm -rf "$TEMP_DIR"
