{ pkgs, ... }:
{
  # Backup and Synchronization Tools
  # Comprehensive backup, sync, and data protection solutions
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  home.packages = with pkgs; [
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
    # checksec # Linux-specific security checker (macOS has different tools)
  ];

  # Note: Backup scripts and automation would be configured in Home Manager
  # This module focuses on system-level backup and sync packages
}
