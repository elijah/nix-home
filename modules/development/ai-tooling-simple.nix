{ pkgs, ... }:
{
  # AI Tooling and Development Enhancements
  # Comprehensive AI integration for modern development workflows

  environment.systemPackages = with pkgs; [
    # AI-powered CLI tools
    gh-copilot # GitHub Copilot CLI (renamed from github-copilot-cli)
    aichat # AI chat in terminal

    # Code analysis and generation
    tree-sitter # Parser generator for code analysis

    # API tools for AI services
    curl # HTTP client for API calls
    jq # JSON processor
    yq # YAML processor

    # Development tools enhanced by AI
    git # Version control with AI integrations
    fzf # Fuzzy finder (enhanced with AI suggestions)
    ripgrep # Fast text search
    bat # Syntax highlighting

    # Documentation and knowledge management
    pandoc # Document converter

    # Python for AI/ML development
    python3 # Python interpreter
    python3Packages.pip # Python package manager
    python3Packages.requests # HTTP library
    python3Packages.openai # OpenAI API
    python3Packages.anthropic # Anthropic/Claude API
  ];

  # Environment variables for AI tools
  environment.variables = {
    # AI service configurations
    OPENAI_API_BASE = "https://api.openai.com/v1";
  };

  # Note: AI prompt management and detailed configuration are handled in Home Manager
}
