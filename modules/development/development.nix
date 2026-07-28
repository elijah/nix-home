{ pkgs, lib, config, ... }:
{
  # Development Tools and Language Ecosystems
  # Comprehensive development environment with multiple language support
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  home.packages = with pkgs; [
    # Core Development Tools
    git # Version control
    gh # GitHub CLI
    delta # Better git diff (was git-delta)
    lazygit # Terminal UI for git

    # Multiple Language Support
    # nodejs_20 # Node.js LTS - use Homebrew nvm/volta/bun instead (tests fail on nix-darwin)
    # nodePackages.npm # npm package manager
    # nodePackages.yarn # Yarn package manager
    bun # Fast JavaScript runtime and package manager
    mise # Polyglot runtime/tool version manager (was a Linux apt vendor-repo entry; plain cross-platform nixpkgs package)

    # Rust Ecosystem
    rustc # Rust compiler
    cargo # Rust package manager
    rustfmt # Rust formatter
    clippy # Rust linter

    # Go Ecosystem
    go # Go compiler
    gopls # Go language server
    golangci-lint # Go linter

    # Python Development (beyond data science)
    python312Packages.pip
    python312Packages.virtualenv
    pipenv # Python package management (standalone)
    poetry # Python package management (top-level)
    python312Packages.black # Python formatter
    python312Packages.flake8 # Python linter
    python312Packages.mypy # Python type checker

    # Ruby
    ruby # Ruby interpreter
    bundler # Ruby package manager

    # Database Tools
    sqlite # SQLite database
    postgresql_15 # PostgreSQL client
    # mysql80 # MySQL client - has build issues on nix-darwin, use Homebrew instead

    # API and Web Development
    httpie # HTTP client
    curl # Transfer tool
    wget # Web getter
    postman # API development tool

    # Container and Cloud Tools
    docker # Container platform
    docker-compose # Container orchestration
    kubernetes-helm # Kubernetes package manager

    # Text Editors and IDEs
    vim # Classic vim
    # vscode - macOS-only GUI app, configured separately in home/vscode.nix
    # emacs - configured separately in emacs.nix

    # Build and Deployment Tools
    gnumake # Build automation (GNU make)
    cmake # Cross-platform build system
    ninja # Build system

    # Monitoring and Debugging
    htop # Process viewer
    btop # Modern process viewer
    hyperfine # Benchmarking tool
    # strace               # System call tracer (Linux only - use dtruss on macOS)
    gdb # Debugger
  ];

  # Configure shell environment for development
  home.sessionVariables = {
    # Development paths
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # Tool configurations
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";

    # Nix configuration
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  # Create development directory structure
  home.activation.devSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Setting up development environment..."
    run mkdir -p "${config.home.homeDirectory}/Development/projects"
    run mkdir -p "${config.home.homeDirectory}/Development/experiments"
    run mkdir -p "${config.home.homeDirectory}/Development/learning"
    run mkdir -p "${config.home.homeDirectory}/go/bin"
    run mkdir -p "${config.home.homeDirectory}/go/pkg"
    run mkdir -p "${config.home.homeDirectory}/go/src"
    run mkdir -p "${config.home.homeDirectory}/.cargo"
    run mkdir -p "${config.home.homeDirectory}/.rustup"
  '';
}
