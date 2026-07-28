{ config, pkgs, lib, ... }:

{
  # Knowledge Management and Writing Tools
  # Includes Obsidian, note-taking tools, and document processing
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager). GUI apps (Obsidian, Logseq) work under
  # WSL2 thanks to WSLg's built-in Wayland/X11 forwarding.

  home.packages = with pkgs; [
    # Obsidian for visual knowledge management
    obsidian # Main Obsidian application
    obsidian-export # Export Obsidian vaults to Markdown

    # Markdown Tools
    markdown-oxide # Markdown LSP server inspired by Obsidian
    marksman # Language server for Markdown
    pandoc # Universal document converter

    # Note-taking and PKM Tools
    # zettlr                 # Markdown-based writing app (x86 Linux only)
    logseq # Local-first knowledge management

    # Document Processing
    typst # Modern typesetting system
    # texlive.combined.scheme-full # Complete LaTeX distribution (disabled: frequently fails to substitute from cache)

    # Text Processing
    ripgrep # Fast text search tool
    fd # Fast find alternative
    bat # Better cat with syntax highlighting
    fzf # Fuzzy finder

    # Writing and Editing
    neovim # Modern vim editor
    typos # Source code spell checker
    vale # Prose linter

    # File Management for Knowledge Base
    rclone # Cloud storage sync
    rsync # File synchronization

    # RPG/Gaming knowledge tools
    # dice                   # Command-line dice roller (not available)
    fortune # Random quotes/inspiration
  ] ++ lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
    # x86-64 Linux only packages
    zettlr # Markdown-based writing app (x86 Linux only)
  ];

  # Environment variables for better text processing
  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim"; # Can be overridden by other modules
    PAGER = lib.mkDefault "less -R"; # Can be overridden by other modules
    BAT_THEME = "Solarized (dark)";
    DENDRON_ROOT = "${config.home.homeDirectory}/knowledge/dendron";
    ORG_ROAM_DIR = "${config.home.homeDirectory}/knowledge/org-roam";
    RPG_NOTES_DIR = "${config.home.homeDirectory}/knowledge/rpg-notes";
  };

  # Create directories for knowledge management
  home.activation.knowledgeSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Setting up knowledge management directories..."
    run mkdir -p "${config.home.homeDirectory}/Documents/Knowledge"
    run mkdir -p "${config.home.homeDirectory}/Documents/Notes"
    run mkdir -p "${config.home.homeDirectory}/Documents/Research"
    run mkdir -p "${config.home.homeDirectory}/knowledge/obsidian"
    run mkdir -p "${config.home.homeDirectory}/knowledge/dendron"
    run mkdir -p "${config.home.homeDirectory}/knowledge/org-roam"
    run mkdir -p "${config.home.homeDirectory}/knowledge/rpg-notes/campaigns"
    run mkdir -p "${config.home.homeDirectory}/knowledge/rpg-notes/characters"
    run mkdir -p "${config.home.homeDirectory}/knowledge/rpg-notes/worldbuilding"
    run mkdir -p "${config.home.homeDirectory}/knowledge/rpg-notes/rules"
  '';

  # No chown needed here: home-manager activation always runs as the target
  # user, so files/directories created above are already correctly owned
  # (unlike the old nix-darwin system.activationScripts, which ran as root).
}
