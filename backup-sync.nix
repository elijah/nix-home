{ pkgs, ... }:
{
  # Backup and Synchronization Tools
  # Comprehensive backup, sync, and data protection solutions

  environment.systemPackages = with pkgs; [
    # Modern backup tools
    restic # Fast, secure backup program
    borgbackup # Deduplicating backup program (borg)
    duplicity # Encrypted bandwidth-efficient backup

    # Cloud sync
    rclone # Sync files to/from cloud storage
    rsync # Fast file synchronization

    # Version control for configs
    git-crypt # Transparent file encryption in git
    git-secret # Store secrets in git repositories

    # File monitoring and sync
    syncthing # Continuous file synchronization
    unison # File synchronizer

    # Archive tools
    p7zip # 7-Zip file archiver
    zip # ZIP archiver
    unzip # ZIP extractor
    gzip # GZIP compression

    # Data recovery
    testdisk # Data recovery software (includes photorec)

    # File integrity
    rhash # Utility for computing hash sums
    checksec # Tool for checking security properties
  ];

  # Backup scripts and automation
  home.file = {
    ".local/bin/backup-home" = {
      text = ''
        #!/usr/bin/env bash
        # Automated home directory backup using restic
        
        set -euo pipefail
        
        BACKUP_REPO="''${BACKUP_REPO:-$HOME/.local/share/backups}"
        BACKUP_PASSWORD_FILE="''${BACKUP_PASSWORD_FILE:-$HOME/.config/restic/password}"
        
        log() {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
        }
        
        if [[ ! -f "$BACKUP_PASSWORD_FILE" ]]; then
            log "❌ Backup password file not found: $BACKUP_PASSWORD_FILE"
            log "Create it with: echo 'your-secure-password' > $BACKUP_PASSWORD_FILE && chmod 600 $BACKUP_PASSWORD_FILE"
            exit 1
        fi
        
        export RESTIC_REPOSITORY="$BACKUP_REPO"
        export RESTIC_PASSWORD_FILE="$BACKUP_PASSWORD_FILE"
        
        # Initialize repository if it doesn't exist
        if ! restic snapshots >/dev/null 2>&1; then
            log "🔧 Initializing backup repository..."
            restic init
        fi
        
        log "🔄 Starting backup..."
        restic backup \
            --verbose \
            --exclude-caches \
            --exclude '*.tmp' \
            --exclude '.DS_Store' \
            --exclude 'node_modules' \
            --exclude '.git' \
            --exclude 'target' \
            --exclude '__pycache__' \
            "$HOME/Documents" \
            "$HOME/Projects" \
            "$HOME/.config" \
            "$HOME/.ssh" \
            || log "⚠️ Backup completed with warnings"
        
        log "🧹 Cleaning old snapshots..."
        restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
        
        log "✅ Backup completed successfully"
      '';
      executable = true;
    };

    ".local/bin/backup-system" = {
      text = ''
        #!/usr/bin/env bash
        # System configuration backup
        
        set -euo pipefail
        
        BACKUP_DIR="$HOME/.local/share/system-backups/$(date +%Y-%m-%d)"
        
        log() {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
        }
        
        mkdir -p "$BACKUP_DIR"
        
        log "🔄 Backing up system configurations..."
        
        # Backup Homebrew packages
        if command -v brew >/dev/null 2>&1; then
            log "📦 Backing up Homebrew packages..."
            brew list > "$BACKUP_DIR/brew-list.txt"
            brew list --cask > "$BACKUP_DIR/brew-cask-list.txt"
        fi
        
        # Backup installed applications
        if [[ -d "/Applications" ]]; then
            log "📱 Backing up application list..."
            ls -la /Applications > "$BACKUP_DIR/applications.txt"
        fi
        
        # Backup VS Code extensions
        if command -v code >/dev/null 2>&1; then
            log "🔌 Backing up VS Code extensions..."
            code --list-extensions > "$BACKUP_DIR/vscode-extensions.txt"
        fi
        
        # Backup system preferences (macOS)
        if [[ "$(uname)" == "Darwin" ]]; then
            log "⚙️ Backing up system preferences..."
            defaults read > "$BACKUP_DIR/system-defaults.plist" 2>/dev/null || true
        fi
        
        log "✅ System backup completed: $BACKUP_DIR"
      '';
      executable = true;
    };

    ".local/bin/sync-dotfiles" = {
      text = ''
        #!/usr/bin/env bash
        # Dotfiles synchronization script
        
        set -euo pipefail
        
        DOTFILES_REPO="''${DOTFILES_REPO:-$HOME/.dotfiles}"
        
        log() {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
        }
        
        if [[ ! -d "$DOTFILES_REPO/.git" ]]; then
            log "❌ Dotfiles repository not found: $DOTFILES_REPO"
            log "Initialize with: git clone <your-dotfiles-repo> $DOTFILES_REPO"
            exit 1
        fi
        
        cd "$DOTFILES_REPO"
        
        log "🔄 Syncing dotfiles..."
        
        # Pull latest changes
        git pull origin main || git pull origin master
        
        # Sync common dotfiles
        files=(
            ".zshrc"
            ".gitconfig"
            ".gitignore_global"
            ".editorconfig"
        )
        
        for file in "''${files[@]}"; do
            if [[ -f "$DOTFILES_REPO/$file" ]]; then
                log "📄 Syncing $file"
                cp "$DOTFILES_REPO/$file" "$HOME/$file"
            fi
        done
        
        log "✅ Dotfiles sync completed"
      '';
      executable = true;
    };
  };

  # Backup configuration directories
  system.activationScripts.backup-setup.text = ''
    echo "Setting up backup infrastructure..."
    
    # Create backup directories
    mkdir -p /Users/elw/.local/share/backups
    mkdir -p /Users/elw/.local/share/system-backups
    mkdir -p /Users/elw/.config/restic
    
    # Set proper permissions
    chmod 700 /Users/elw/.local/share/backups
    chmod 700 /Users/elw/.config/restic
    
    echo "Backup infrastructure setup completed"
  '';

  # Environment variables for backup tools
  environment.variables = {
    RESTIC_REPOSITORY = "$HOME/.local/share/backups";
    RESTIC_PASSWORD_FILE = "$HOME/.config/restic/password";
  };
}
