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

## 🎯 **Usage Examples**

### **Enable Security + Productivity:**
```nix
# In flake.nix
./security.nix
./productivity.nix
```

### **Enable Full DevOps Stack:**
```nix
# In flake.nix
./cloud-networking.nix
./sysadmin.nix
./security.nix
```

### **Enable Creative Workflow:**
```nix
# In flake.nix
./design-media.nix
./productivity.nix
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
