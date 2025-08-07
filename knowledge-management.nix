{ config, pkgs, lib, ... }:

{
  # Knowledge Management and Writing Tools
  # Includes Obsidian, note-taking tools, and document processing

  environment.systemPackages = with pkgs; [
    # Obsidian for visual knowledge management
    obsidian                  # Main Obsidian application
    obsidian-export          # Export Obsidian vaults to Markdown
    
    # Markdown Tools
    markdown-oxide           # Markdown LSP server inspired by Obsidian
    marksman                 # Language server for Markdown
    pandoc                   # Universal document converter
    
    # Note-taking and PKM Tools
    # zettlr                 # Markdown-based writing app (x86 Linux only)
    logseq                   # Local-first knowledge management
    
    # Document Processing
    typst                    # Modern typesetting system
    texlive.combined.scheme-full  # Complete LaTeX distribution
    
    # Text Processing
    ripgrep                  # Fast text search tool
    fd                       # Fast find alternative
    bat                      # Better cat with syntax highlighting
    fzf                      # Fuzzy finder
    
    # Writing and Editing
    neovim                   # Modern vim editor
    typos                    # Source code spell checker
    vale                     # Prose linter
    
    # File Management for Knowledge Base
    rclone                   # Cloud storage sync
    rsync                    # File synchronization
    
    # RPG/Gaming knowledge tools
    # dice                   # Command-line dice roller (not available)
    fortune                  # Random quotes/inspiration
  ] ++ lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
    # x86-64 Linux only packages
    zettlr                   # Markdown-based writing app (x86 Linux only)
  ];

  # Environment variables for better text processing
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less -R";
    BAT_THEME = "Solarized (dark)";
    DENDRON_ROOT = "/Users/elw/knowledge/dendron";
    ORG_ROAM_DIR = "/Users/elw/knowledge/org-roam";
    RPG_NOTES_DIR = "/Users/elw/knowledge/rpg-notes";
  };

  # Create directories for knowledge management
  system.activationScripts.knowledge-setup.text = ''
    echo "Setting up knowledge management directories..."
    mkdir -p /Users/elw/Documents/Knowledge
    mkdir -p /Users/elw/Documents/Notes
    mkdir -p /Users/elw/Documents/Research
    mkdir -p /Users/elw/knowledge/{obsidian,dendron,org-roam,rpg-notes}
    mkdir -p /Users/elw/knowledge/rpg-notes/{campaigns,characters,worldbuilding,rules}
    echo "Knowledge management directories created"
  '';

  # Set proper permissions
  system.activationScripts.set-permissions.text = ''
    chown -R elw:staff /Users/elw/knowledge
  '';
}
