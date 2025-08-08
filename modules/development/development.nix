{ pkgs, ... }:
{
  # Development Tools and Language Ecosystems
  # Comprehensive development environment with multiple language support

  environment.systemPackages = with pkgs; [
    # Core Development Tools
    git # Version control
    gh # GitHub CLI
    delta # Better git diff (was git-delta)
    lazygit # Terminal UI for git

    # Multiple Language Support
    nodejs_20 # Node.js LTS
    nodePackages.npm # npm package manager
    nodePackages.yarn # Yarn package manager
    bun # Fast JavaScript runtime and package manager

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
    mysql80 # MySQL client

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
    vscode # Already configured
    # emacs - configured separately in emacs.nix
    vim # Classic vim

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
  environment.variables = {
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
  system.activationScripts.dev-setup.text = ''
    echo "Setting up development environment..."
    mkdir -p /Users/elw/Development/{projects,experiments,learning}
    mkdir -p /Users/elw/go/{bin,pkg,src}
    mkdir -p /Users/elw/.cargo
    mkdir -p /Users/elw/.rustup
    echo "Development directories created"
  '';
}
