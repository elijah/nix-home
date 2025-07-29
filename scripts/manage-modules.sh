#!/usr/bin/env bash

# Module management script for nix-home
# Usage: ./scripts/manage-modules.sh [enable|disable|list] [module-name]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
FLAKE_FILE="$REPO_DIR/flake.nix"

# Available modules
declare -A MODULES=(
    ["security"]="./security.nix            # Security and privacy tools"
    ["productivity"]="./productivity.nix        # Modern CLI tools and productivity"
    ["cloud-networking"]="./cloud-networking.nix    # Cloud platforms and networking"
    ["design-media"]="./design-media.nix        # Design and media processing tools"
    ["sysadmin"]="./sysadmin.nix           # System administration and DevOps"
    ["data-science"]="./data-science.nix        # R, Jupyter, Python scientific stack"
    ["knowledge-management"]="./knowledge-management.nix # Obsidian, markdown tools, writing"
    ["development"]="./development.nix         # Multi-language dev environment"
    ["shell-enhancements"]="./shell-enhancements.nix    # Modern shell configuration"
    ["performance"]="./performance.nix         # Performance monitoring and optimization"
    ["backup-sync"]="./backup-sync.nix         # Backup and synchronization tools"
    ["network-tools"]="./network-tools.nix     # Network utilities and diagnostics"
)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

list_modules() {
    echo "Available modules:"
    echo "=================="
    for module in "${!MODULES[@]}"; do
        local line="${MODULES[$module]}"
        local status="❌ Disabled"
        
        # Check if module is enabled
        if grep -q "^[[:space:]]*${line%%#*}" "$FLAKE_FILE"; then
            status="✅ Enabled"
        fi
        
        printf "%-20s %s - %s\n" "$module" "$status" "${line#*# }"
    done
}

enable_module() {
    local module="$1"
    
    if [[ ! -v "MODULES[$module]" ]]; then
        echo "❌ Unknown module: $module"
        echo "Available modules: ${!MODULES[*]}"
        exit 1
    fi
    
    local line="${MODULES[$module]}"
    local module_line="${line%%#*}"
    
    # Check if already enabled
    if grep -q "^[[:space:]]*${module_line}" "$FLAKE_FILE"; then
        log "✅ Module '$module' is already enabled"
        return 0
    fi
    
    # Enable the module by uncommenting it
    if grep -q "^[[:space:]]*#[[:space:]]*${module_line}" "$FLAKE_FILE"; then
        # Uncomment existing commented line
        sed -i '' "s|^\\([[:space:]]*\\)#\\([[:space:]]*${module_line}\\)|\\1\\2|" "$FLAKE_FILE"
        log "✅ Enabled module: $module"
    else
        echo "❌ Module line not found in flake.nix for: $module"
        exit 1
    fi
}

disable_module() {
    local module="$1"
    
    if [[ ! -v "MODULES[$module]" ]]; then
        echo "❌ Unknown module: $module"
        echo "Available modules: ${!MODULES[*]}"
        exit 1
    fi
    
    local line="${MODULES[$module]}"
    local module_line="${line%%#*}"
    
    # Check if already disabled
    if grep -q "^[[:space:]]*#[[:space:]]*${module_line}" "$FLAKE_FILE"; then
        log "❌ Module '$module' is already disabled"
        return 0
    fi
    
    # Disable the module by commenting it
    if grep -q "^[[:space:]]*${module_line}" "$FLAKE_FILE"; then
        # Comment the line
        sed -i '' "s|^\\([[:space:]]*\\)\\(${module_line}\\)|\\1# \\2|" "$FLAKE_FILE"
        log "❌ Disabled module: $module"
    else
        echo "❌ Module line not found in flake.nix for: $module"
        exit 1
    fi
}

show_help() {
    cat << EOF
Nix-Home Module Manager

Usage: $0 [command] [module-name]

Commands:
  list              List all available modules and their status
  enable [module]   Enable a specific module
  disable [module]  Disable a specific module
  help              Show this help message

Available modules: ${!MODULES[*]}

Examples:
  $0 list
  $0 enable security
  $0 disable productivity
  $0 enable cloud-networking

After enabling/disabling modules, run: ./scripts/update.sh
EOF
}

main() {
    cd "$REPO_DIR"
    
    case "${1:-}" in
        "list")
            list_modules
            ;;
        "enable")
            if [[ -z "${2:-}" ]]; then
                echo "❌ Module name required"
                echo "Available modules: ${!MODULES[*]}"
                exit 1
            fi
            enable_module "$2"
            echo ""
            echo "🔄 To apply changes, run: ./scripts/update.sh"
            ;;
        "disable")
            if [[ -z "${2:-}" ]]; then
                echo "❌ Module name required"
                echo "Available modules: ${!MODULES[*]}"
                exit 1
            fi
            disable_module "$2"
            echo ""
            echo "🔄 To apply changes, run: ./scripts/update.sh"
            ;;
        "help"|"--help"|"-h"|"")
            show_help
            ;;
        *)
            echo "❌ Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
