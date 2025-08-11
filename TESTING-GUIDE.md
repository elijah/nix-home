# 🧪 TESTING AND DEPLOYMENT GUIDE

## Comprehensive Testing Infrastructure

Your nix-darwin setup now includes comprehensive testing capabilities:

### 🔧 Tool Testing Script (`scripts/test-tools.sh`)

**Usage:**
```bash
# Test all tools and integrations
./scripts/test-tools.sh all

# Test specific categories
./scripts/test-tools.sh tools           # Development tools
./scripts/test-tools.sh editors         # Emacs & VS Code
./scripts/test-tools.sh home-manager    # Home Manager integration
./scripts/test-tools.sh alfred          # Alfred workflows
```

**What it tests:**
- ✅ Core development tools (git, nodejs, python, rust, go)
- ✅ Shell enhancements (starship, fzf, ripgrep, bat, eza)
- ✅ Knowledge management tools (obsidian, pandoc, typst)
- ✅ System monitoring tools (htop, btop, hyperfine)
- ✅ Emacs installation and configuration loading
- ✅ VS Code installation and extensions
- ✅ Home Manager profile and dotfiles
- ✅ Environment variables (EDITOR, PAGER)
- ✅ Alfred workflow integration

### 🎯 Management Script (`scripts/manage.sh`)

**Enhanced with testing commands:**
```bash
# Deploy and test workflow
./scripts/manage.sh build              # Test build
./scripts/manage.sh deploy             # Deploy configuration
./scripts/manage.sh test               # Run comprehensive tests
./scripts/manage.sh test-tools         # Test just CLI tools
./scripts/manage.sh test-editors       # Test Emacs & VS Code
./scripts/manage.sh health             # System health check
```

### 🔍 Flake Checks (Enhanced)

**Built-in validation:**
- `config-builds` - Test all configurations build
- `module-syntax` - Validate all module syntax
- `format-check` - Nix code formatting
- `tool-check` - Core tool availability
- `home-manager-syntax` - Home Manager config validation
- `script-validation` - Shell script syntax checking

**Run with:**
```bash
nix flake check                        # Full validation suite
nix build .#checks.aarch64-darwin.tool-check  # Specific test
```

## 🚀 Deployment Workflow

### First Time Setup
1. **Build Test**: `./scripts/manage.sh build`
2. **Deploy**: `./scripts/manage.sh deploy`  
3. **Test Tools**: `./scripts/manage.sh test`
4. **Health Check**: `./scripts/manage.sh health`

### Regular Updates
1. **Update Dependencies**: `./scripts/manage.sh update`
2. **Build Test**: `./scripts/manage.sh build`
3. **Deploy**: `./scripts/manage.sh deploy`
4. **Validate**: `./scripts/manage.sh test-tools`

### Troubleshooting
1. **Syntax Issues**: `nix flake check --no-build`
2. **Build Problems**: `./scripts/manage.sh build`
3. **Tool Issues**: `./scripts/test-tools.sh tools`
4. **Rollback**: `./scripts/manage.sh rollback`

## 📊 Test Categories

### Core Development Tools
- Git, GitHub CLI
- Node.js, Python, Rust, Go
- Shell tools (zsh, starship, fzf, ripgrep, bat, eza)
- Network tools (curl, wget, nmap, speedtest)

### Knowledge Management
- Obsidian, Pandoc, Typst
- Text processing (vale, typos)

### System Tools  
- Performance monitoring (htop, btop, hyperfine)
- File tools (duf, dust, ncdu)

### Editor Integration
- **Emacs**: Installation, config loading, org-roam setup
- **VS Code**: Installation, extension count, version check

### Home Manager Integration
- Profile existence and activation
- Dotfiles management (.gitignore_global, .editorconfig, SSH config)
- XDG directory structure
- Environment variables (EDITOR, PAGER)

### Alfred Workflows
- Workflow directory detection
- Workflow count verification

## 🎯 Success Criteria

**Ready for deployment when:**
- ✅ `nix flake check` passes
- ✅ `./scripts/manage.sh build` succeeds
- ✅ All package conflicts resolved
- ✅ No environment variable conflicts

**Deployed successfully when:**
- ✅ `./scripts/manage.sh test` passes
- ✅ Core tools respond to version checks
- ✅ Editors start without errors
- ✅ Home Manager dotfiles are in place
- ✅ Environment variables are set correctly

## 🔧 Advanced Testing

### Individual Test Components
```bash
# Test specific tools exist and work
command -v git && git --version
command -v code && code --version
command -v emacs && emacs --batch --eval "(message \"OK\")"

# Test Home Manager state
ls -la ~/.local/state/nix/profiles/home-manager/
echo $EDITOR $PAGER

# Test VS Code extensions
code --list-extensions | wc -l
```

### Environment Validation
```bash
# Check nix-darwin generation
darwin-rebuild --list-generations

# Check Home Manager generation  
home-manager generations

# Check active profiles
nix profile list
```

This comprehensive testing infrastructure ensures your nix-darwin setup works not just in theory, but in practice! 🎉
