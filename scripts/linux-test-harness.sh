#!/usr/bin/env bash
# Linux personality test harness
#
# Uses Lima (limactl) to run a real Ubuntu 24.04 VM on macOS, standing in
# for a real WSL2 instance, so the "elw-linux" home-manager personality
# (home/linux, modules/linux) can be built/applied/tested without needing
# an actual Windows/WSL2 machine. See docs/LINUX-WSL2.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
VM_NAME="nix-home-linux-test"
TEMPLATE="${REPO_DIR}/lima/ubuntu-2404-wsl-test.yaml"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

require_limactl() {
    if ! command -v limactl >/dev/null 2>&1; then
        log_error "limactl not found. Install it with: brew install lima (or colima, which bundles it)"
        exit 1
    fi
}

vm_exists() {
    limactl list --format '{{.Name}}' 2>/dev/null | grep -qx "$VM_NAME"
}

vm_running() {
    limactl list --format '{{.Name}} {{.Status}}' 2>/dev/null | grep -q "^${VM_NAME} Running$"
}

# Run a command inside the VM as the default (non-root) user.
vm_shell() {
    limactl shell "$VM_NAME" -- bash -lc "$1"
}

cmd_up() {
    require_limactl
    if vm_running; then
        log_info "$VM_NAME is already running"
        return 0
    fi
    if vm_exists; then
        log_info "Starting existing $VM_NAME instance..."
        limactl start "$VM_NAME"
    else
        log_info "Creating $VM_NAME from ${TEMPLATE}..."
        limactl start --name="$VM_NAME" "$TEMPLATE"
    fi
    log_success "$VM_NAME is up"
}

# Lima's `vz` driver runs the VM natively matching the host architecture
# (aarch64 on Apple Silicon, x86_64 on Intel Macs), so pick the matching
# flake attribute rather than assuming x86_64-linux.
flake_attr() {
    local arch
    arch="$(vm_shell "uname -m")"
    case "$arch" in
        aarch64) echo "elw-linux-aarch64" ;;
        x86_64) echo "elw-linux" ;;
        *)
            log_error "Unrecognized guest architecture: $arch"
            exit 1
            ;;
    esac
}

cmd_switch() {
    cmd_up
    local attr
    attr="$(flake_attr)"
    log_info "Running 'home-manager switch --flake .#${attr}' inside $VM_NAME..."
    # HOME is exported explicitly: Lima names the guest account's real home
    # /home/<user>.guest (to avoid clashing with mounted host paths), but
    # home/linux/default.nix expects a plain /home/elw (correct for a real
    # WSL2/Ubuntu box). The Lima template symlinks /home/elw -> elw.guest
    # for this reason; home-manager itself insists $HOME match
    # home.homeDirectory exactly, so it must be set here rather than left
    # to the account's /etc/passwd entry.
    vm_shell "export HOME=/home/elw && cd '${REPO_DIR}' && nix run --extra-experimental-features 'nix-command flakes' home-manager/release-26.05 -- switch --flake .#${attr} -b backup"
    log_success "home-manager switch completed"
}

cmd_bootstrap() {
    cmd_up
    log_info "Running linux-bootstrap (apt / vendor-repo / homebrew fallback) inside $VM_NAME..."
    vm_shell "linux-bootstrap"
    log_success "linux-bootstrap completed"
}

cmd_check() {
    cmd_up
    local attr
    attr="$(flake_attr)"
    log_info "Building .#homeConfigurations.${attr}.activationPackage inside $VM_NAME (native build, no cross-compilation needed)..."
    vm_shell "cd '${REPO_DIR}' && nix build --extra-experimental-features 'nix-command flakes' --no-link --print-out-paths .#homeConfigurations.${attr}.activationPackage"
    log_success "${attr} activation package builds successfully"
}

cmd_shell() {
    require_limactl
    if ! vm_running; then
        log_warning "$VM_NAME is not running; starting it first"
        cmd_up
    fi
    exec limactl shell "$VM_NAME"
}

cmd_down() {
    require_limactl
    if vm_running; then
        log_info "Stopping $VM_NAME..."
        limactl stop "$VM_NAME"
        log_success "$VM_NAME stopped"
    else
        log_info "$VM_NAME is not running"
    fi
}

cmd_destroy() {
    require_limactl
    if vm_exists; then
        log_info "Deleting $VM_NAME..."
        limactl delete --force "$VM_NAME"
        log_success "$VM_NAME deleted"
    else
        log_info "$VM_NAME does not exist"
    fi
}

show_help() {
    cat <<EOF
Linux personality test harness (Lima-backed Ubuntu 24.04 VM)

Usage: $0 [COMMAND]

Commands:
    up          Create (if needed) and start the test VM
    check       Build .#homeConfigurations.elw-linux.activationPackage inside the VM
    switch      Run 'home-manager switch --flake .#elw-linux' inside the VM
    bootstrap   Run the 'linux-bootstrap' apt/vendor-repo/homebrew script inside the VM
    shell       Open an interactive shell inside the VM
    down        Stop the VM (keeps disk state)
    destroy     Delete the VM entirely
    help        Show this help message

Examples:
    $0 up          # First-time setup: creates & boots the Ubuntu 24.04 VM, installs Nix
    $0 check       # Fast feedback: does the flake even build on real Linux?
    $0 switch      # Actually apply the elw-linux home-manager configuration
    $0 bootstrap   # Install apt/vendor-repo/homebrew(linux) packages
    $0 shell       # Poke around inside the VM directly
    $0 destroy     # Tear down when done testing
EOF
}

case "${1:-help}" in
    up) cmd_up ;;
    check) cmd_check ;;
    switch) cmd_switch ;;
    bootstrap) cmd_bootstrap ;;
    shell) cmd_shell ;;
    down) cmd_down ;;
    destroy) cmd_destroy ;;
    help | --help | -h) show_help ;;
    *)
        log_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
