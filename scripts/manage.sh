#!/usr/bin/env bash
# Nix-Darwin Setup and Management Script

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    cat << EOF
Nix-Darwin Management Script

Usage: $0 [COMMAND]

Commands:
    deploy           Deploy the configuration (nix-darwin switch)
    build            Build without deploying (dry-run)
    test             Run comprehensive tool and integration tests
    test-tools       Test development tools only
    test-editors     Test editor integrations (Emacs, VS Code)
    test-home-manager Test Home Manager integration
    check            Run flake checks
    update           Update flake inputs
    health           Check system health
    rollback         Rollback to previous generation
    help             Show this help message

Examples:
    $0 deploy           # Deploy elw configuration
    $0 build            # Test build without applying
    $0 test             # Run all functionality tests
    $0 test-tools       # Test just the CLI tools
    $0 check            # Validate configuration syntax
    $0 update           # Update all dependencies
EOF
}

deploy_config() {
    log_info "Deploying nix-darwin configuration..."
    
    # Check if in correct directory
    if [[ ! -f "$FLAKE_DIR/flake.nix" ]]; then
        log_error "flake.nix not found in $FLAKE_DIR"
        exit 1
    fi
    
    cd "$FLAKE_DIR"
    
    log_info "Running deployment..."
    nix run nix-darwin -- switch --flake .#elw
    
    log_success "Deployment completed!"
}

build_config() {
    log_info "Building configuration (dry-run)..."
    
    cd "$FLAKE_DIR"
    
    if nix build .#darwinConfigurations.elw.system --dry-run; then
        log_success "Configuration builds successfully!"
    else
        log_error "Configuration failed to build!"
        exit 1
    fi
}

check_config() {
    log_info "Running configuration checks..."
    
    cd "$FLAKE_DIR"
    
    # Quick syntax check
    log_info "Checking syntax..."
    if nix build .#checks.aarch64-darwin.module-syntax --no-link --quiet; then
        log_success "Module syntax check passed!"
    else
        log_error "Module syntax check failed!"
        exit 1
    fi
    
    # Format check
    log_info "Checking formatting..."
    if nix build .#checks.aarch64-darwin.format-check --no-link --quiet; then
        log_success "Format check passed!"
    else
        log_error "Format check failed!"
        exit 1
    fi
}

update_flake() {
    log_info "Updating flake inputs..."
    
    cd "$FLAKE_DIR"
    
    nix flake update
    
    log_success "Flake inputs updated!"
    log_warning "Remember to test the configuration before deploying!"
}

health_check() {
    log_info "Running system health checks..."
    
    # Check if nix-darwin is active
    if command -v darwin-rebuild >/dev/null 2>&1; then
        log_success "nix-darwin is installed and available"
    else
        log_warning "nix-darwin command not found"
    fi
    
    # Check Nix version
    if command -v nix >/dev/null 2>&1; then
        NIX_VERSION=$(nix --version)
        log_success "Nix is available: $NIX_VERSION"
    else
        log_error "Nix is not installed or not in PATH"
    fi
    
    # Check for Home Manager
    if command -v home-manager >/dev/null 2>&1; then
        log_success "Home Manager is available"
    else
        log_warning "Home Manager not found in PATH"
    fi
    
    # Check disk space
    AVAILABLE_SPACE=$(df -h /nix | awk 'NR==2 {print $4}')
    log_info "Available space in /nix: $AVAILABLE_SPACE"
}

rollback_config() {
    log_info "Rolling back to previous generation..."
    
    darwin-rebuild rollback
    
    log_success "Rollback completed!"
}

# Main script logic
case "${1:-help}" in
    deploy)
        deploy_config
        ;;
    build)
        build_config
        ;;
    test)
        log_info "Running comprehensive tool tests..."
        ./scripts/test-tools.sh all
        ;;
    test-tools)
        log_info "Testing development tools only..."
        ./scripts/test-tools.sh tools
        ;;
    test-editors)
        log_info "Testing editor integrations..."
        ./scripts/test-tools.sh editors
        ;;
    test-home-manager)
        log_info "Testing Home Manager integration..."
        ./scripts/test-tools.sh home-manager
        ;;
    check)
        check_config
        ;;
    update)
        update_flake
        ;;
    health)
        health_check
        ;;
    rollback)
        rollback_config
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        log_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
