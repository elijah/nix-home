#!/usr/bin/env bash
# Comprehensive Tool and Integration Testing Script

set -euo pipefail

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
    echo -e "${GREEN}[✅]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[⚠️]${NC} $1"
}

log_error() {
    echo -e "${RED}[❌]${NC} $1"
}

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

test_command() {
    local name="$1"
    local command="$2"
    local expected_pattern="${3:-.*}"
    
    log_info "Testing $name..."
    
    if command -v "${command%% *}" >/dev/null 2>&1; then
        if eval "$command" 2>/dev/null | grep -E "$expected_pattern" >/dev/null; then
            log_success "$name is working"
            ((TESTS_PASSED++))
            return 0
        else
            log_error "$name command failed or unexpected output"
            ((TESTS_FAILED++))
            FAILED_TESTS+=("$name")
            return 1
        fi
    else
        log_error "$name is not installed or not in PATH"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$name")
        return 1
    fi
}

test_file_exists() {
    local name="$1"
    local file="$2"
    
    log_info "Testing $name file..."
    
    if [[ -f "$file" ]]; then
        log_success "$name file exists: $file"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "$name file missing: $file"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$name file")
        return 1
    fi
}

test_directory_exists() {
    local name="$1"
    local dir="$2"
    
    log_info "Testing $name directory..."
    
    if [[ -d "$dir" ]]; then
        log_success "$name directory exists: $dir"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "$name directory missing: $dir"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$name directory")
        return 1
    fi
}

show_summary() {
    echo ""
    echo "🧪 TEST SUMMARY"
    echo "=============="
    echo "✅ Passed: $TESTS_PASSED"
    echo "❌ Failed: $TESTS_FAILED"
    echo "📊 Total:  $((TESTS_PASSED + TESTS_FAILED))"
    
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo ""
        echo "❌ Failed Tests:"
        for test in "${FAILED_TESTS[@]}"; do
            echo "  - $test"
        done
        echo ""
        echo "💡 Run with 'deploy' mode if tools aren't installed yet"
        return 1
    else
        echo ""
        echo "🎉 All tests passed!"
        return 0
    fi
}

test_core_tools() {
    echo "🔧 TESTING CORE DEVELOPMENT TOOLS"
    echo "================================="
    
    # Version control
    test_command "Git" "git --version" "git version"
    test_command "GitHub CLI" "gh --version" "gh version"
    
    # Editors
    test_command "VS Code" "code --version" "[0-9]+\.[0-9]+\.[0-9]+"
    test_command "Neovim" "nvim --version" "NVIM"
    
    # Shell tools
    test_command "Zsh" "zsh --version" "zsh"
    test_command "Starship" "starship --version" "starship"
    test_command "Fzf" "fzf --version" "[0-9]+\.[0-9]+"
    test_command "Ripgrep" "rg --version" "ripgrep"
    test_command "Bat" "bat --version" "bat"
    test_command "Eza" "eza --version" "eza"
    
    # Development tools
    test_command "Node.js" "node --version" "v[0-9]+"
    test_command "Python" "python3 --version" "Python"
    test_command "Rust" "rustc --version" "rustc"
    test_command "Go" "go version" "go version"
    
    # Network tools
    test_command "Curl" "curl --version" "curl"
    test_command "Wget" "wget --version" "GNU Wget"
    test_command "Nmap" "nmap --version" "Nmap"
    test_command "Speedtest" "speedtest-cli --version" "[0-9]+\.[0-9]+"
}

test_knowledge_management() {
    echo ""
    echo "📚 TESTING KNOWLEDGE MANAGEMENT TOOLS" 
    echo "====================================="
    
    # Note-taking and PKM
    test_command "Obsidian" "obsidian --version" ".*" || log_warning "Obsidian may need GUI test"
    test_command "Pandoc" "pandoc --version" "pandoc"
    test_command "Typst" "typst --version" "typst"
    
    # Text processing
    test_command "Vale" "vale --version" "vale"
    test_command "Typos" "typos --version" "[0-9]+\.[0-9]+"
}

test_system_tools() {
    echo ""
    echo "⚙️ TESTING SYSTEM TOOLS"
    echo "======================="
    
    # System monitoring
    test_command "Htop" "htop --version" "htop"
    test_command "Btop" "btop --version" "btop"
    test_command "NCDU" "ncdu --version" "ncdu"
    
    # Performance tools
    test_command "Hyperfine" "hyperfine --version" "hyperfine"
    test_command "Stress" "stress --version" "stress"
    
    # File tools
    test_command "Duf" "duf --version" "duf"
    test_command "Dust" "dust --version" "Dust"
}

test_emacs_integration() {
    echo ""
    echo "📝 TESTING EMACS INTEGRATION"
    echo "============================"
    
    # Check if Emacs is installed
    if ! command -v emacs >/dev/null 2>&1; then
        log_error "Emacs not found in PATH"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("Emacs installation")
        return 1
    fi
    
    log_success "Emacs found in PATH"
    ((TESTS_PASSED++))
    
    # Test Emacs version
    test_command "Emacs version" "emacs --version" "GNU Emacs"
    
    # Check for org-roam directory
    test_directory_exists "Org-roam directory" "$HOME/Documents/org-roam"
    
    # Test Emacs configuration
    if timeout 10 emacs --batch --eval "(message \"Emacs config test\")" 2>/dev/null; then
        log_success "Emacs configuration loads successfully"
        ((TESTS_PASSED++))
    else
        log_error "Emacs configuration failed to load"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("Emacs configuration")
    fi
}

test_vscode_integration() {
    echo ""
    echo "🖥️ TESTING VS CODE INTEGRATION"  
    echo "=============================="
    
    # Check VS Code installation
    if ! command -v code >/dev/null 2>&1; then
        log_error "VS Code not found in PATH"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("VS Code installation")
        return 1
    fi
    
    log_success "VS Code found in PATH"
    ((TESTS_PASSED++))
    
    # Test VS Code version
    test_command "VS Code version" "code --version" "[0-9]+\.[0-9]+\.[0-9]+"
    
    # List installed extensions
    if code --list-extensions >/dev/null 2>&1; then
        EXTENSION_COUNT=$(code --list-extensions | wc -l)
        log_success "VS Code extensions installed: $EXTENSION_COUNT"
        ((TESTS_PASSED++))
    else
        log_error "Failed to list VS Code extensions"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("VS Code extensions")
    fi
}

test_home_manager_integration() {
    echo ""
    echo "🏠 TESTING HOME MANAGER INTEGRATION"
    echo "==================================="
    
    # Check if Home Manager is active
    if [[ -f "$HOME/.local/state/nix/profiles/home-manager/activate" ]]; then
        log_success "Home Manager profile exists"
        ((TESTS_PASSED++))
    else
        log_warning "Home Manager profile not found (may not be deployed yet)"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("Home Manager profile")
    fi
    
    # Check dotfiles managed by Home Manager
    test_file_exists "Git ignore global" "$HOME/.gitignore_global"
    test_file_exists "Editor config" "$HOME/.editorconfig"
    test_file_exists "SSH config" "$HOME/.ssh/config"
    
    # Check XDG directories
    test_directory_exists "XDG config" "$HOME/.config"
    test_directory_exists "XDG data" "$HOME/.local/share"
    
    # Check if shell environment is configured
    if [[ -n "${EDITOR:-}" ]]; then
        log_success "EDITOR environment variable set: $EDITOR"
        ((TESTS_PASSED++))
    else
        log_warning "EDITOR environment variable not set"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("EDITOR environment variable")
    fi
    
    if [[ -n "${PAGER:-}" ]]; then
        log_success "PAGER environment variable set: $PAGER"
        ((TESTS_PASSED++))
    else
        log_warning "PAGER environment variable not set"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("PAGER environment variable")
    fi
}

test_alfred_integration() {
    echo ""
    echo "🔍 TESTING ALFRED INTEGRATION"
    echo "============================="
    
    # Check Alfred workflows directory
    ALFRED_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows"
    if [[ -d "$ALFRED_DIR" ]]; then
        WORKFLOW_COUNT=$(find "$ALFRED_DIR" -name "*.alfredworkflow" 2>/dev/null | wc -l || echo 0)
        log_success "Alfred workflows directory exists with $WORKFLOW_COUNT workflows"
        ((TESTS_PASSED++))
    else
        log_warning "Alfred workflows directory not found (Alfred may not be installed)"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("Alfred workflows directory")
    fi
}

# Main test execution
main() {
    echo "🧪 COMPREHENSIVE TOOL AND INTEGRATION TESTING"
    echo "=============================================="
    echo ""
    
    # Parse arguments
    case "${1:-all}" in
        "tools")
            test_core_tools
            test_knowledge_management
            test_system_tools
            ;;
        "editors")
            test_emacs_integration
            test_vscode_integration
            ;;
        "home-manager")
            test_home_manager_integration
            ;;
        "alfred")
            test_alfred_integration
            ;;
        "all"|"")
            test_core_tools
            test_knowledge_management
            test_system_tools
            test_emacs_integration
            test_vscode_integration
            test_home_manager_integration
            test_alfred_integration
            ;;
        "help"|"--help"|"-h")
            echo "Usage: $0 [CATEGORY]"
            echo ""
            echo "Categories:"
            echo "  tools       - Test core development tools"
            echo "  editors     - Test Emacs and VS Code integration"
            echo "  home-manager - Test Home Manager integration"
            echo "  alfred      - Test Alfred workflow integration"
            echo "  all         - Run all tests (default)"
            echo "  help        - Show this help"
            exit 0
            ;;
        *)
            log_error "Unknown test category: $1"
            echo "Run '$0 help' for usage information"
            exit 1
            ;;
    esac
    
    show_summary
}

# Run main function with all arguments
main "$@"
