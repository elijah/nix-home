{ pkgs, ... }:
{
  # Modern Shell Enhancement
  # Supercharge your shell experience with modern tools and configurations

  environment.systemPackages = with pkgs; [
    # Modern shell tools
    zsh # Z shell
    starship # Shell prompt
    zoxide # Better cd
    atuin # Shell history
    fzf # Fuzzy finder
    
    # Terminal multiplexers
    tmux # Terminal multiplexer
    screen # Screen terminal multiplexer
    
    # Enhanced CLI tools
    eza # Better ls
    bat # Better cat
    ripgrep # Better grep
    fd # Better find
    
    # Development tools
    direnv # Environment management
    just # Command runner
  ];

  # Enhanced environment variables
  environment.variables = {
    # Better defaults
    EDITOR = "code --wait";
    VISUAL = "code --wait";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # Development
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";

    # Nix configuration
    NIXPKGS_ALLOW_UNFREE = "1";

    # History
    HISTSIZE = "50000";
    SAVEHIST = "50000";
    HISTFILE = "$HOME/.local/share/zsh/history";
  };

  # Note: Detailed shell configuration (zsh programs, completions, etc.) 
  # are handled in Home Manager. This module provides system-level packages.
}
