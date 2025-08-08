# 🏠 Nix-Home: Modular nix-darwin Configuration

A comprehensive, modular nix-darwin configuration for macOS development environments.

## ✨ Features

- **🧩 Modular Architecture**: Organized into logical categories (system, development, applications, workflows)
- **👩‍💻 Multiple Configurations**: Minimal, standard, and full-featured setups
- **🎯 Profile-Based**: Pre-configured combinations for specific use cases (DevOps, TTRPG, Creative, AI)
- **🔧 Development-Focused**: Comprehensive tooling for multiple programming languages
- **📝 Knowledge Management**: Integrated org-roam, Dendron, and Obsidian support
- **🔍 Validation & Testing**: Built-in checks and validation scripts
- **📚 Well-Documented**: Comprehensive documentation and templates

## 🚀 Quick Start

### Prerequisites

1. Install Nix with flakes enabled
2. Install nix-darwin
3. Clone this repository

### Apply Configuration

```bash
# Clone the repository
git clone <repository-url> nix-home
cd nix-home

# Apply the main configuration
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#elw --impure
```

### Alternative Configurations

```bash
# Minimal development setup
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#minimal --impure

# Full-featured setup (all modules)
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#full --impure
```

## 📁 Repository Structure

```
nix-home/
├── 📄 flake.nix                 # Main flake configuration
├── 🧩 modules/                  # Organized module configuration
│   ├── 🖥️  system/             # System-level configuration
│   ├── 💻 development/         # Development tools and environments  
│   ├── 📱 applications/        # Desktop applications and software
│   └── ⚡ workflows/           # Automation and workflow enhancements
├── 📋 profiles/                 # Pre-configured module combinations
├── 🏠 home/                     # Home Manager configuration
├── 🔧 scripts/                  # Utility scripts
├── 📝 templates/                # Templates for new modules
├── 📚 docs/                     # Documentation
└── 🎯 assets/                   # Static assets and configurations
```

## 🎯 What's Included

### Development Tools
- **Languages**: Go, Rust, Python, Node.js, Ruby with full ecosystems
- **DevOps**: Docker, Kubernetes, Terraform, cloud tools
- **Editors**: Emacs 30 with org-roam, VS Code with comprehensive extensions
- **Version Control**: Git, GitHub CLI, advanced diff tools

### Knowledge Management
- **Emacs**: org-roam for structured note-taking
- **VS Code**: Dendron extension for hierarchical notes
- **Applications**: Obsidian, Logseq for various note-taking styles

### System Enhancement
- **Shell**: Enhanced zsh with modern tools
- **Productivity**: Alfred workflows, automation tools
- **Security**: GPG, security tools
- **Performance**: Monitoring and optimization tools

## 🧩 Module Categories

| Category | Description | Example Modules |
|----------|-------------|-----------------|
| **System** | Core system configuration | homebrew, security, performance |
| **Development** | Programming tools & environments | development, sysadmin, data-science |
| **Applications** | Desktop software | emacs, vscode-extensions, productivity |
| **Workflows** | Automation & enhancement | alfred, shell-enhancements, ai-workflows |

## 📋 Configuration Profiles

- **DevOps**: Complete DevOps engineer setup
- **TTRPG**: Tabletop RPG gaming and content creation tools
- **Creative**: Design and media production tools
- **AI**: AI development and research tools

## 🔧 Development

### Development Environment

```bash
# Enter development shell
nix develop

# Module development shell (with linting tools)
nix develop .#modules
```

### Creating New Modules

```bash
# Use the module template
nix flake init --template .#module

# Move to appropriate category
mv default.nix modules/applications/my-module.nix
```

### Testing & Validation

```bash
# Validate all configurations
nix flake check --impure

# Format code
nix fmt

# Test build without applying
nix build .#darwinConfigurations.elw.system --impure
```

## 📚 Documentation

- **[Architecture Guide](docs/ARCHITECTURE.md)**: Detailed structure explanation
- **[Usage Guide](docs/USAGE.md)**: How to use and customize
- **[Module Development](docs/MODULE-GUIDE.md)**: Creating new modules

## 🛠️ Common Tasks

### Adding Packages
1. Find the appropriate module in `modules/`
2. Add packages to `environment.systemPackages`
3. Test with `nix flake check --impure`
4. Apply with `darwin-rebuild switch`

### Managing VS Code Extensions
Edit `modules/applications/vscode-extensions.nix`

### Homebrew Packages
Edit `modules/system/homebrew.nix` or the main `Brewfile`

## 🆘 Troubleshooting

### Environment Variables
The configuration automatically sets `NIXPKGS_ALLOW_UNFREE=1` and other necessary environment variables.

### Common Issues
- **Build failures**: Run `nix flake check --impure` for validation
- **Unfree packages**: Ensure environment variables are set
- **Module conflicts**: Review enabled modules for conflicts

### Getting Help
1. Check documentation in `docs/`
2. Use `nix develop` for debugging
3. Review build logs with `nix log`

## 🤝 Contributing

1. Create modules using the provided templates
2. Follow the modular architecture principles
3. Test thoroughly with `nix flake check`
4. Update documentation as needed

## 📄 License

[Add your license here]

---

**Made with ❤️ and Nix for productive development environments**
