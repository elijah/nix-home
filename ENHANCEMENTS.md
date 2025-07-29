# 🚀 Nix-Home Configuration Enhancements

This document outlines the enhancement modules available for your nix-home configuration. Each module is optional and can be enabled by uncommenting it in `flake.nix`.

## 📋 **Quick Enable Guide**

To enable any module, edit `flake.nix` and uncomment the desired line:

```nix
# Enhancement modules (uncomment to enable)
./security.nix            # Security and privacy tools
./productivity.nix        # Modern CLI tools and productivity
./cloud-networking.nix    # Cloud platforms and networking
./design-media.nix        # Design and media processing tools
./sysadmin.nix           # System administration and DevOps
./shell-enhancements.nix  # Modern shell configuration
./performance.nix         # Performance monitoring and optimization
./backup-sync.nix         # Backup and synchronization tools
./network-tools.nix       # Network utilities and diagnostics
```

Then rebuild: `./scripts/update.sh`

---

## 🛡️ **Security Enhancement (`security.nix`)**

**What it includes:**

- Password management (pass, passage)
- Encryption tools (age, sops, GPG)
- Network security (nmap, wireshark)
- System auditing (lynis, rkhunter)
- Privacy tools (tor, torsocks)
- Certificate management (step-cli)

**Perfect for:**

- Security-conscious developers
- DevSecOps workflows
- Privacy-focused computing
- Certificate and secret management

---

## ⚡ **Productivity Enhancement (`productivity.nix`)**

**What it includes:**

- Modern CLI replacements (eza, bat, fd, ripgrep, zoxide)
- File managers (ranger, broot, nnn)
- System monitoring (btop, bandwhich, dust)
- Enhanced shell experience (zsh with plugins)
- Text processing (sd, choose, miller)
- Git enhancements (git-absorb, lazygit)

**Perfect for:**

- Power users wanting modern CLI tools
- Developers seeking productivity boosts
- Anyone who spends time in terminal

---

## ☁️ **Cloud & Networking Enhancement (`cloud-networking.nix`)**

**What it includes:**

- Cloud CLIs (AWS, Azure, Google Cloud)
- Kubernetes ecosystem (kubectl, k9s, helm)
- Container tools (docker-compose, dive)
- Infrastructure as Code (terraform, packer)
- Network diagnostics (dig, mtr, traceroute)
- Database clients (postgresql, mysql, redis)

**Perfect for:**

- DevOps engineers
- Cloud architects
- SRE (Site Reliability Engineers)
- Kubernetes operators

---

## 🎨 **Design & Media Enhancement (`design-media.nix`)**

**What it includes:**

- Image processing (imagemagick, oxipng, jpegoptim)
- Vector graphics (inkscape)
- Video tools (ffmpeg, yt-dlp)
- Audio processing (sox, lame, flac)
- PDF manipulation (qpdf, poppler)
- Diagram creation (graphviz, plantuml)

**Perfect for:**

- Content creators
- Web developers
- Designers
- Video/audio editors

---

## 🔧 **System Administration Enhancement (`sysadmin.nix`)**

**What it includes:**

- System monitoring (htop, iotop, lsof)
- Performance analysis (hyperfine, stress)
- Configuration management (ansible)
- Infrastructure monitoring (prometheus, grafana)
- Backup tools (borg, restic)
- Network performance (iperf3)

**Perfect for:**

- System administrators
- DevOps engineers
- Infrastructure managers
- Performance engineers

---

## 🏠 **Dotfiles Management Enhancement (`home/dotfiles.nix`)**

**What it includes:**

- Automatic dotfile syncing
- XDG directory compliance
- SSH configuration management
- Clean home directory organization
- Personal scripts management

**Perfect for:**

- Organized developers
- Multi-machine setups
- Configuration version control

---

## 🚀 **Shell Enhancement (`shell-enhancements.nix`)**

**What it includes:**

- Modern Zsh configuration with plugins
- Enhanced completion system
- Smart history management
- Git integration in prompt
- Modern tool aliases (eza, bat, fd, etc.)
- Custom functions and utilities

**Perfect for:**

- Power users seeking better shell experience
- Developers wanting efficient CLI workflows
- Anyone spending significant time in terminal

---

## ⚡ **Performance Monitoring (`performance.nix`)**

**What it includes:**

- System monitoring (htop, btop, iotop)
- Performance analysis (hyperfine, stress)
- Disk analysis (ncdu, dust, duf)
- Network performance testing
- Memory debugging tools
- System optimizations for macOS

**Perfect for:**

- Performance optimization
- System troubleshooting
- Resource monitoring
- Benchmarking workflows

---

## 💾 **Backup & Sync (`backup-sync.nix`)**

**What it includes:**

- Modern backup tools (restic, borg)
- Cloud synchronization (rclone, rsync)
- Automated backup scripts
- File integrity checking
- Data recovery tools
- Git-based secret management

**Perfect for:**

- Data protection strategies
- Automated backup workflows
- Multi-device synchronization
- Disaster recovery planning

---

## 🌐 **Network Tools (`network-tools.nix`)**

**What it includes:**

- Network diagnostics (nmap, wireshark, mtr)
- Performance testing (iperf3, speedtest)
- HTTP tools (curl, httpie, wget)
- VPN and security tools
- Custom network scripts
- SSL/TLS utilities

**Perfect for:**

- Network troubleshooting
- Security testing
- Performance optimization
- Network administration

---

## 🤖 **AI Tooling (`ai-tooling.nix`)**

**What it includes:**

- GitHub Copilot CLI integration
- AI chat tools (aichat)
- Code analysis and generation tools
- AI development environment setup
- Python/Node.js for AI development
- API testing tools for AI services
- Custom AI assistance scripts

**Perfect for:**

- AI-enhanced development workflows
- Code generation and explanation
- Automated documentation
- API integration with AI services

---

## 🔄 **AI Workflows (`ai-workflows.nix`)**

**What it includes:**

- Automated commit message generation
- AI-powered code review
- Smart refactoring assistance
- Project initialization with AI
- Workflow automation tools
- File watching and auto-processing
- AI debugging assistant

**Perfect for:**

- Automated development workflows
- Intelligent code maintenance
- Project setup automation
- Continuous AI assistance

---

## 🎯 **Usage Examples**

### **Enable Security + Productivity:**

```nix
  imports = [
    ./security.nix
    ./productivity.nix
    ./shell-enhancements.nix
  ];
```

### **Enable Full DevOps Stack:**

```nix
  imports = [
    ./development.nix
    ./cloud-networking.nix
    ./sysadmin.nix
    ./performance.nix
    ./backup-sync.nix
    ./network-tools.nix
  ];
```

### **Enable Creative Workflow:**

```nix
  imports = [
    ./design-media.nix
    ./productivity.nix
    ./knowledge-management.nix
    ./shell-enhancements.nix
  ];
```

### **Enable AI-Enhanced Development:**

```nix
  imports = [
    ./development.nix
    ./ai-tooling.nix
    ./ai-workflows.nix
    ./shell-enhancements.nix
  ];
```

---

## 🔄 **Testing Modules**

1. **Enable a module** by uncommenting it in `flake.nix`
2. **Test build**: `./scripts/build.sh`
3. **Apply changes**: `./scripts/update.sh`
4. **Verify installation**: Check that new tools are available

---

## 📊 **Module Dependencies**

All modules are designed to be:

- ✅ **Independent** - Can be enabled/disabled individually
- ✅ **Lightweight** - Only essential packages included
- ✅ **Conflict-free** - No package conflicts between modules
- ✅ **Documented** - Clear purpose and package lists

---

## 🛠️ **Customization**

Each module can be customized by:

1. **Editing the module file** directly
2. **Adding/removing packages** from the lists
3. **Modifying environment variables** and configurations
4. **Adjusting aliases and functions** as needed

---

## 📈 **Benefits**

- **Modular**: Enable only what you need
- **Organized**: Clear separation of concerns
- **Maintainable**: Easy to update and modify
- **Documented**: Well-documented purpose and contents
- **Professional**: Production-ready configurations

Choose the modules that fit your workflow and enjoy a more powerful nix-home setup!
