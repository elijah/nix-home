{ pkgs, lib, ... }:
{
  # Modern Shell Enhancement
  # Supercharge your shell experience with modern tools and configurations
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  home.packages = with pkgs; [
    # Modern shell tools
    zsh # Z shell
    # starship # Shell prompt - installed via Homebrew for better reliability
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
  home.sessionVariables = {
    # Better defaults. The Linux personality has no VS Code installed (GUI
    # apps are deliberately excluded), so default to a terminal editor there.
    EDITOR = if pkgs.stdenv.isDarwin then "code --wait" else "nvim";
    VISUAL = if pkgs.stdenv.isDarwin then "code --wait" else "nvim";
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
    # HISTFILE is set in home/dotfiles.nix via config.xdg.dataHome (XDG-
    # compliant path) - not duplicated here to avoid a conflicting
    # definition.
  };

  # Note: Detailed shell configuration (zsh programs, completions, etc.)
  # are handled in Home Manager. This module provides shared packages.
}
