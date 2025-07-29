{ pkgs, ... }:
{
  # Knowledge Management and Writing Tools
  # Includes Obsidian, note-taking tools, and document processing

  environment.systemPackages = with pkgs; [
    # Obsidian Knowledge Management
    obsidian                  # Main Obsidian application
    obsidian-export          # Export Obsidian vaults to Markdown
    
    # Markdown Tools
    markdown-oxide           # Markdown LSP server inspired by Obsidian
    marksman                 # Language server for Markdown
    pandoc                   # Universal document converter
    
    # Note-taking and PKM Tools
    zettlr                   # Markdown-based writing app
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
  ];

  # Environment variables for better text processing
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less -R";
    BAT_THEME = "Solarized (dark)";
  };

  # Create directories for knowledge management
  system.activationScripts.knowledge-setup.text = ''
    echo "Setting up knowledge management directories..."
    mkdir -p /Users/elw/Documents/Knowledge
    mkdir -p /Users/elw/Documents/Notes
    mkdir -p /Users/elw/Documents/Research
    echo "Knowledge management directories created"
  '';
}
