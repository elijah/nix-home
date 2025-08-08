{ pkgs, ... }:
{
  # Productivity and Automation Tools
  # Enhance workflow with powerful CLI tools and automation

  environment.systemPackages = with pkgs; [
    # Modern replacements for traditional tools
    eza # Better ls
    bat # Better cat with syntax highlighting
    fd # Better find
    ripgrep # Better grep
    zoxide # Better cd with learning
    fzf # Fuzzy finder

    # File management
    ranger # Terminal file manager
    broot # Tree view and file manager
    nnn # Lightweight file manager

    # System monitoring
    btop # Better top
    iotop # I/O monitoring
    bandwhich # Network utilization by process
    dust # Better du
    duf # Better df

    # Text processing
    sd # Better sed
    choose # Better cut/awk
    csvkit # CSV manipulation
    miller # Data processing

    # JSON/YAML tools
    jq # JSON processor
    yq # YAML processor
    fx # Interactive JSON viewer

    # Network tools
    curl # HTTP client
    httpie # Human-friendly HTTP client
    wget # File downloader

    # Terminal multiplexing
    tmux # Terminal multiplexer
    screen # Terminal multiplexer

    # Archive and compression
    p7zip # 7-Zip
    unzip # ZIP extractor
    zip # ZIP creator

    # Productivity
    just # Command runner
    direnv # Environment management
    starship # Shell prompt
    atuin # Shell history
  ];

  # Note: Shell integrations and program configurations are handled in Home Manager
  # This module focuses on system-level productivity packages
}
