{ pkgs, ... }:
{
  # AI Tooling and Development Enhancements
  # Comprehensive AI integration for modern development workflows

  environment.systemPackages = with pkgs; [
    # AI-powered CLI tools
    github-copilot-cli      # GitHub Copilot CLI
    aichat                  # AI chat in terminal
    
    # Code analysis and generation
    tree-sitter            # Parser generator for code analysis
    
    # API tools for AI services
    curl                   # HTTP client for API calls
    jq                     # JSON processor
    yq                     # YAML processor
    
    # Development tools enhanced by AI
    git                    # Version control with AI integrations
    fzf                    # Fuzzy finder (enhanced with AI suggestions)
    ripgrep               # Fast text search
    bat                   # Syntax highlighting
    
    # Documentation and knowledge management
    pandoc                # Document converter
    
    # Python for AI/ML development
    python3               # Python interpreter
    python3Packages.pip   # Python package manager
    python3Packages.virtualenv  # Virtual environments
    
    # Node.js for AI tool development
    nodejs                # Node.js runtime
    nodePackages.npm      # NPM package manager
    nodePackages.yarn     # Yarn package manager
    
    # API testing and development
    httpie                # Human-friendly HTTP client
    postman              # API development platform
  ];

  # AI-enhanced shell configuration
  environment.shellAliases = {
    # GitHub Copilot CLI shortcuts
    "gcs" = "gh copilot suggest";
    "gce" = "gh copilot explain";
    
    # AI chat and assistance
    "ai" = "aichat";
    "ask" = "aichat";
    "explain" = "aichat 'Explain this command:'";
    
    # Code analysis
    "analyze" = "rg --type py --type js --type ts --type nix";
    "codestat" = "find . -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.nix' | xargs wc -l | sort -n";
    
    # Documentation helpers
    "mkdocs" = "pandoc --from markdown --to html";
    "readme" = "bat README.md";
    
    # API testing shortcuts
    "apitest" = "httpie";
    "json" = "jq .";
    "yaml" = "yq .";
  };

  # AI development environment setup
  home.file = {
    ".local/bin/ai-setup" = {
      text = ''
        #!/usr/bin/env bash
        # AI development environment setup script
        
        set -euo pipefail
        
        echo "🤖 Setting up AI development environment..."
        
        # Create AI workspace directories
        mkdir -p ~/workspace/ai-projects
        mkdir -p ~/workspace/ai-experiments
        mkdir -p ~/.config/ai-tools
        mkdir -p ~/.local/share/ai-prompts
        
        # Setup Python virtual environment for AI development
        if [[ ! -d ~/.local/share/ai-venv ]]; then
            echo "📦 Creating Python virtual environment for AI tools..."
            python3 -m venv ~/.local/share/ai-venv
        fi
        
        # Activate and install common AI packages
        source ~/.local/share/ai-venv/bin/activate
        pip install --upgrade pip
        pip install --quiet \
            openai \
            anthropic \
            requests \
            python-dotenv \
            rich \
            typer \
            pydantic \
            langchain \
            langchain-openai \
            langchain-anthropic
        
        echo "✅ AI development environment ready!"
        echo "💡 Activate with: source ~/.local/share/ai-venv/bin/activate"
      '';
      executable = true;
    };
    
    ".local/bin/ai-commit" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered git commit message generator
        
        set -euo pipefail
        
        if ! command -v gh >/dev/null 2>&1; then
            echo "❌ GitHub CLI not found. Install with: nix-env -iA nixpkgs.gh"
            exit 1
        fi
        
        # Check if there are staged changes
        if ! git diff --cached --quiet; then
            echo "🤖 Generating commit message from staged changes..."
            
            # Get the diff of staged changes
            DIFF=$(git diff --cached)
            
            # Use GitHub Copilot to suggest commit message
            COMMIT_MSG=$(echo "$DIFF" | gh copilot suggest "Generate a concise git commit message for these changes" --type shell | tail -n 1)
            
            echo "📝 Suggested commit message:"
            echo "   $COMMIT_MSG"
            echo
            read -p "Use this message? (y/N): " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git commit -m "$COMMIT_MSG"
                echo "✅ Committed with AI-generated message!"
            else
                echo "💭 Opening editor for manual commit message..."
                git commit
            fi
        else
            echo "❌ No staged changes found. Stage changes first with 'git add'"
        fi
      '';
      executable = true;
    };
    
    ".local/bin/ai-explain" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered code explanation tool
        
        set -euo pipefail
        
        if [[ $# -eq 0 ]]; then
            echo "Usage: $0 <file> [specific_function_or_line]"
            echo "Example: $0 script.py"
            echo "Example: $0 script.py main_function"
            exit 1
        fi
        
        FILE="$1"
        TARGET="''${2:-}"
        
        if [[ ! -f "$FILE" ]]; then
            echo "❌ File not found: $FILE"
            exit 1
        fi
        
        echo "🤖 Analyzing code: $FILE"
        
        if [[ -n "$TARGET" ]]; then
            echo "🔍 Focusing on: $TARGET"
        fi
        
        # Use GitHub Copilot CLI to explain the code
        if command -v gh >/dev/null 2>&1; then
            cat "$FILE" | gh copilot explain
        elif command -v aichat >/dev/null 2>&1; then
            echo "📖 Code Analysis:" | aichat
            cat "$FILE" | aichat "Explain this code, focusing on its purpose, key functions, and how it works:"
        else
            echo "❌ No AI tools available. Install GitHub CLI or aichat."
            exit 1
        fi
      '';
      executable = true;
    };
    
    ".local/bin/ai-review" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered code review tool
        
        set -euo pipefail
        
        echo "🤖 AI Code Review Assistant"
        
        # Check if we're in a git repository
        if ! git rev-parse --git-dir >/dev/null 2>&1; then
            echo "❌ Not in a git repository"
            exit 1
        fi
        
        # Get recent changes
        echo "📊 Analyzing recent changes..."
        
        # Option 1: Review staged changes
        if ! git diff --cached --quiet; then
            echo "🔍 Found staged changes. Reviewing..."
            DIFF=$(git diff --cached)
            echo "$DIFF" | gh copilot suggest "Review this code change for potential issues, improvements, and best practices" --type shell
        
        # Option 2: Review recent commits
        elif [[ $(git log --oneline -n 5 | wc -l) -gt 0 ]]; then
            echo "🔍 Reviewing last commit..."
            DIFF=$(git show HEAD)
            echo "$DIFF" | gh copilot suggest "Review this code change for potential issues, improvements, and best practices" --type shell
        
        else
            echo "❌ No changes to review"
            exit 1
        fi
      '';
      executable = true;
    };
    
    ".local/bin/ai-docs" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered documentation generator
        
        set -euo pipefail
        
        if [[ $# -eq 0 ]]; then
            echo "Usage: $0 <file_or_directory>"
            echo "Example: $0 src/"
            echo "Example: $0 main.py"
            exit 1
        fi
        
        TARGET="$1"
        
        if [[ ! -e "$TARGET" ]]; then
            echo "❌ Path not found: $TARGET"
            exit 1
        fi
        
        echo "📝 Generating documentation for: $TARGET"
        
        # Create docs directory
        mkdir -p docs
        
        if [[ -f "$TARGET" ]]; then
            # Single file documentation
            FILENAME=$(basename "$TARGET" .py .js .ts .nix)
            OUTPUT="docs/$FILENAME.md"
            
            echo "🤖 Analyzing $TARGET..."
            {
                echo "# Documentation for $TARGET"
                echo
                echo "Generated on $(date)"
                echo
                cat "$TARGET" | aichat "Generate comprehensive documentation for this code including: purpose, usage examples, function descriptions, and installation/setup instructions. Format as markdown."
            } > "$OUTPUT"
            
            echo "✅ Documentation saved to: $OUTPUT"
        
        elif [[ -d "$TARGET" ]]; then
            # Directory documentation
            OUTPUT="docs/$(basename "$TARGET").md"
            
            echo "🤖 Analyzing directory structure..."
            {
                echo "# Documentation for $TARGET"
                echo
                echo "Generated on $(date)"
                echo
                echo "## Directory Structure"
                echo '```'
                find "$TARGET" -type f -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.nix" | head -20
                echo '```'
                echo
                
                # Get overview of main files
                find "$TARGET" -maxdepth 2 -name "*.py" -o -name "*.js" -o -name "*.ts" | head -5 | while read -r file; do
                    echo "### $(basename "$file")"
                    head -20 "$file" | aichat "Briefly describe what this code does (1-2 sentences):"
                    echo
                done
            } > "$OUTPUT"
            
            echo "✅ Documentation saved to: $OUTPUT"
        fi
      '';
      executable = true;
    };
    
    ".local/bin/prompt-library" = {
      text = ''
        #!/usr/bin/env bash
        # AI prompt library manager
        
        set -euo pipefail
        
        PROMPT_DIR="$HOME/.local/share/ai-prompts"
        mkdir -p "$PROMPT_DIR"
        
        case "''${1:-list}" in
            "list")
                echo "📚 Available prompts:"
                ls -1 "$PROMPT_DIR"/*.txt 2>/dev/null | xargs -I {} basename {} .txt || echo "No prompts found"
                ;;
            "add")
                if [[ $# -lt 3 ]]; then
                    echo "Usage: $0 add <name> <prompt_text>"
                    exit 1
                fi
                NAME="$2"
                PROMPT="$3"
                echo "$PROMPT" > "$PROMPT_DIR/$NAME.txt"
                echo "✅ Saved prompt: $NAME"
                ;;
            "get")
                if [[ $# -lt 2 ]]; then
                    echo "Usage: $0 get <name>"
                    exit 1
                fi
                NAME="$2"
                if [[ -f "$PROMPT_DIR/$NAME.txt" ]]; then
                    cat "$PROMPT_DIR/$NAME.txt"
                else
                    echo "❌ Prompt not found: $NAME"
                fi
                ;;
            "use")
                if [[ $# -lt 2 ]]; then
                    echo "Usage: $0 use <name> [input]"
                    exit 1
                fi
                NAME="$2"
                INPUT="''${3:-}"
                if [[ -f "$PROMPT_DIR/$NAME.txt" ]]; then
                    PROMPT=$(cat "$PROMPT_DIR/$NAME.txt")
                    if [[ -n "$INPUT" ]]; then
                        echo "$INPUT" | aichat "$PROMPT"
                    else
                        aichat "$PROMPT"
                    fi
                else
                    echo "❌ Prompt not found: $NAME"
                fi
                ;;
            *)
                echo "Usage: $0 {list|add|get|use}"
                echo "  list          - List all saved prompts"
                echo "  add <name> <prompt> - Save a new prompt"
                echo "  get <name>    - Display a prompt"
                echo "  use <name> [input] - Use a prompt with optional input"
                ;;
        esac
      '';
      executable = true;
    };
  };

  # Create default AI prompts
  home.activation.ai-prompts = ''
    mkdir -p ~/.local/share/ai-prompts
    
    # Code review prompt
    cat > ~/.local/share/ai-prompts/code-review.txt << 'EOF'
Review this code for:
1. Potential bugs or security issues
2. Performance improvements
3. Code clarity and maintainability
4. Best practices adherence
5. Suggestions for optimization
EOF
    
    # Documentation prompt
    cat > ~/.local/share/ai-prompts/document.txt << 'EOF'
Generate comprehensive documentation for this code including:
1. Purpose and overview
2. Function/method descriptions
3. Usage examples
4. Installation/setup instructions
5. Dependencies and requirements
Format as clear, well-structured markdown.
EOF
    
    # Debugging prompt
    cat > ~/.local/share/ai-prompts/debug.txt << 'EOF'
Help me debug this code by:
1. Identifying potential issues
2. Suggesting debugging strategies
3. Explaining error messages
4. Recommending fixes
5. Providing test cases
EOF
    
    # Optimization prompt
    cat > ~/.local/share/ai-prompts/optimize.txt << 'EOF'
Optimize this code for:
1. Performance and efficiency
2. Memory usage
3. Readability and maintainability
4. Modern best practices
5. Error handling
Provide before/after comparisons and explanations.
EOF
  '';

  # AI tool configuration
  home.sessionVariables = {
    AI_WORKSPACE = "$HOME/workspace/ai-projects";
    OPENAI_API_KEY_FILE = "$HOME/.config/ai-tools/openai.key";
    ANTHROPIC_API_KEY_FILE = "$HOME/.config/ai-tools/anthropic.key";
  };

  # Enhanced Git configuration for AI integration
  programs.git = {
    enable = true;
    aliases = {
      ai-commit = "!ai-commit";
      ai-review = "!ai-review";
      explain = "!gh copilot explain";
    };
  };

  # Zsh integration for AI tools
  programs.zsh = {
    enable = true;
    initExtra = ''
      # AI tool aliases and functions
      alias ai-env='source ~/.local/share/ai-venv/bin/activate'
      
      # Quick AI assistance function
      ask() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: ask <question>"
          return 1
        fi
        aichat "$*"
      }
      
      # Code explanation shortcut
      explain-cmd() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: explain-cmd <command>"
          return 1
        fi
        gh copilot explain "$*"
      }
      
      # AI-powered directory search
      ai-find() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: ai-find <description>"
          return 1
        fi
        find . -type f -name "*" | fzf --preview 'bat --color=always {}' --query "$*"
      }
    '';
  };
}
