{ pkgs, ... }:
{
  # Productivity and Automation Tools
  # Enhance workflow with powerful CLI tools and automation

  environment.systemPackages = with pkgs; [
    # Modern replacements for traditional tools
    eza                       # Better ls
    bat                       # Better cat with syntax highlighting
    fd                        # Better find
    ripgrep                   # Better grep
    zoxide                    # Better cd with learning
    fzf                       # Fuzzy finder
    
    # File management
    ranger                    # Terminal file manager
    broot                     # Tree view and file manager
    nnn                       # Lightweight file manager
    
    # System monitoring
    btop                      # Better top
    iotop                     # I/O monitoring
    bandwhich                 # Network utilization by process
    dust                      # Better du
    duf                       # Better df
    
    # Text processing
    sd                        # Better sed
    choose                    # Better cut/awk
    csvkit                    # CSV manipulation
    miller                    # Data processing
    
    # JSON/YAML tools
    jq                        # JSON processor
    yq                        # YAML processor
    fx                        # Interactive JSON viewer
    
    # Network tools
    curl                      # HTTP client
    httpie                    # Human-friendly HTTP client
    wget                      # File downloader
    aria2                     # Advanced downloader
    
    # Archive tools
    unzip                     # ZIP extraction
    p7zip                     # 7-Zip support
    unrar                     # RAR extraction
    
    # Version control enhancements
    git-absorb               # Auto-squash commits
    git-trim                 # Clean up branches
    gitui                    # Terminal git UI
    lazygit                  # Simple terminal git UI
    
    # Clipboard and screenshots
    pbcopy                   # macOS clipboard (should be available)
    # Add screenshot tools if needed
    
    # Task automation
    just                     # Command runner
    watchexec                # File watcher and command runner
    entr                     # File watcher
    
    # Time tracking
    timewarrior              # Time tracking
    
    # Note-taking and documentation
    glow                     # Markdown renderer
    pandoc                   # Document converter
    
    # Process management
    pgrep                    # Process finder
    pkill                    # Process killer
    htop                     # Process viewer
  ];

  # Shell integrations and configurations
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      # Modern tool aliases
      ls = "eza --icons --git";
      ll = "eza -la --icons --git";
      tree = "eza --tree --icons";
      cat = "bat";
      find = "fd";
      grep = "rg";
      cd = "z";  # zoxide integration
      
      # System monitoring
      top = "btop";
      du = "dust";
      df = "duf";
      
      # Quick file operations
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      
      # Git enhancements
      glog = "git log --oneline --graph --decorate --all";
      gdiff = "git diff --word-diff";
      gstash = "git stash push -m";
    };
    
    initExtra = ''
      # Zoxide initialization
      eval "$(zoxide init zsh)"
      
      # FZF key bindings
      source <(fzf --zsh)
      
      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # Quick edit function
      edit() {
        if [[ -n $1 ]]; then
          code "$1"
        else
          code .
        fi
      }
    '';
  };

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    ];
  };
}
