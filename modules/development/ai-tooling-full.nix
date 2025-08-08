{ pkgs, ... }:
{
  # AI Tooling and Development Enhancements
  # Comprehensive AI integration for modern development workflows

  environment.systemPackages = with pkgs; [
    # AI-powered CLI tools
    gh-copilot # GitHub Copilot CLI (renamed from github-copilot-cli)
    aichat # AI chat in terminal
    # Note: Gemini CLI and Claude CLI will be installed via pip in ai-setup

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
    python3Packages.virtualenv # Virtual environments

    # Node.js for AI tool development
    nodejs # Node.js runtime
    nodePackages.npm # NPM package manager
    nodePackages.yarn # Yarn package manager

    # API testing and development
    httpie # Human-friendly HTTP client
    postman # API development platform
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

    # Google Gemini shortcuts
    "gemini" = "gemini-cli";
    "gem" = "gemini-cli";
    "gask" = "gemini-ask";

    # Claude shortcuts
    "claude" = "claude-cli";
    "cask" = "claude-ask";
    "ccode" = "claude-code";

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
            google-generativeai \
            requests \
            python-dotenv \
            rich \
            typer \
            pydantic \
            langchain \
            langchain-openai \
            langchain-anthropic \
            langchain-google-genai
        
        # Install CLI tools
        echo "🔧 Installing AI CLI tools..."
        
        # Install Google Gemini CLI (unofficial but functional)
        pip install --quiet google-gemini-cli || echo "Note: Gemini CLI not available via pip, will create wrapper"
        
        # Install Claude CLI (unofficial)
        pip install --quiet claude-cli || echo "Note: Claude CLI not available via pip, will create wrapper"
        
        echo "✅ AI development environment ready!"
        echo "💡 Activate with: source ~/.local/share/ai-venv/bin/activate"
        echo "🔑 Configure API keys:"
        echo "   - Google: ~/.config/ai-tools/google.key"
        echo "   - Anthropic: ~/.config/ai-tools/anthropic.key"
        echo "   - OpenAI: ~/.config/ai-tools/openai.key"
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

    ".local/bin/gemini-cli" = {
      text = ''
                #!/usr/bin/env bash
                # Google Gemini CLI wrapper
        
                set -euo pipefail
        
                API_KEY_FILE="$HOME/.config/ai-tools/google.key"
        
                if [[ ! -f "$API_KEY_FILE" ]]; then
                    echo "❌ Google API key not found. Please save your key to: $API_KEY_FILE"
                    echo "💡 Get your key from: https://makersuite.google.com/app/apikey"
                    exit 1
                fi
        
                API_KEY=$(cat "$API_KEY_FILE")
        
                if [[ $# -eq 0 ]]; then
                    echo "Usage: $0 <prompt>"
                    echo "Example: $0 'Explain Python generators'"
                    exit 1
                fi
        
                PROMPT="$*"
        
                # Activate AI environment
                source ~/.local/share/ai-venv/bin/activate 2>/dev/null || true
        
                # Use Python to call Gemini API
                python3 << EOF
        import google.generativeai as genai
        import os
        import sys

        genai.configure(api_key="$API_KEY")
        model = genai.GenerativeModel('gemini-pro')

        try:
            response = model.generate_content("$PROMPT")
            print(response.text)
        except Exception as e:
            print(f"❌ Error: {e}", file=sys.stderr)
            sys.exit(1)
        EOF
      '';
      executable = true;
    };

    ".local/bin/gemini-ask" = {
      text = ''
        #!/usr/bin/env bash
        # Interactive Gemini chat
        
        set -euo pipefail
        
        echo "🤖 Gemini Chat (type 'exit' to quit)"
        echo "=================================="
        
        while true; do
            echo -n "You: "
            read -r input
            
            if [[ "$input" == "exit" || "$input" == "quit" ]]; then
                echo "👋 Goodbye!"
                break
            fi
            
            if [[ -n "$input" ]]; then
                echo "Gemini:"
                gemini-cli "$input"
                echo
            fi
        done
      '';
      executable = true;
    };

    ".local/bin/claude-cli" = {
      text = ''
                #!/usr/bin/env bash
                # Claude CLI wrapper
        
                set -euo pipefail
        
                API_KEY_FILE="$HOME/.config/ai-tools/anthropic.key"
        
                if [[ ! -f "$API_KEY_FILE" ]]; then
                    echo "❌ Anthropic API key not found. Please save your key to: $API_KEY_FILE"
                    echo "💡 Get your key from: https://console.anthropic.com/"
                    exit 1
                fi
        
                API_KEY=$(cat "$API_KEY_FILE")
        
                if [[ $# -eq 0 ]]; then
                    echo "Usage: $0 <prompt>"
                    echo "Example: $0 'Write a Python function to parse JSON'"
                    exit 1
                fi
        
                PROMPT="$*"
        
                # Activate AI environment
                source ~/.local/share/ai-venv/bin/activate 2>/dev/null || true
        
                # Use Python to call Claude API
                python3 << EOF
        import anthropic
        import os
        import sys

        client = anthropic.Anthropic(api_key="$API_KEY")

        try:
            response = client.messages.create(
                model="claude-3-sonnet-20240229",
                max_tokens=1000,
                messages=[{"role": "user", "content": "$PROMPT"}]
            )
            print(response.content[0].text)
        except Exception as e:
            print(f"❌ Error: {e}", file=sys.stderr)
            sys.exit(1)
        EOF
      '';
      executable = true;
    };

    ".local/bin/claude-ask" = {
      text = ''
        #!/usr/bin/env bash
        # Interactive Claude chat
        
        set -euo pipefail
        
        echo "🤖 Claude Chat (type 'exit' to quit)"
        echo "===================================="
        
        while true; do
            echo -n "You: "
            read -r input
            
            if [[ "$input" == "exit" || "$input" == "quit" ]]; then
                echo "👋 Goodbye!"
                break
            fi
            
            if [[ -n "$input" ]]; then
                echo "Claude:"
                claude-cli "$input"
                echo
            fi
        done
      '';
      executable = true;
    };

    ".local/bin/claude-code" = {
      text = ''
                #!/usr/bin/env bash
                # Claude code analysis and generation
        
                set -euo pipefail
        
                if [[ $# -eq 0 ]]; then
                    echo "Usage: $0 {analyze|generate|review} [file|prompt]"
                    echo
                    echo "Commands:"
                    echo "  analyze <file>    - Analyze code file"
                    echo "  generate <prompt> - Generate code from prompt"
                    echo "  review <file>     - Code review"
                    echo "  refactor <file>   - Suggest refactoring"
                    exit 1
                fi
        
                COMMAND="$1"
                shift
        
                case "$COMMAND" in
                    "analyze")
                        if [[ $# -eq 0 || ! -f "$1" ]]; then
                            echo "❌ Please provide a valid file to analyze"
                            exit 1
                        fi
                        FILE="$1"
                        echo "🔍 Analyzing $FILE with Claude..."
                        CONTENT=$(cat "$FILE")
                        claude-cli "Analyze this code and explain what it does, identify potential issues, and suggest improvements:

        $CONTENT"
                        ;;
                    "generate")
                        if [[ $# -eq 0 ]]; then
                            echo "❌ Please provide a prompt for code generation"
                            exit 1
                        fi
                        PROMPT="$*"
                        echo "🔧 Generating code with Claude..."
                        claude-cli "Generate clean, well-documented code for: $PROMPT. Include comments and follow best practices."
                        ;;
                    "review")
                        if [[ $# -eq 0 || ! -f "$1" ]]; then
                            echo "❌ Please provide a valid file to review"
                            exit 1
                        fi
                        FILE="$1"
                        echo "👁️  Reviewing $FILE with Claude..."
                        CONTENT=$(cat "$FILE")
                        claude-cli "Perform a thorough code review of this code. Check for bugs, security issues, performance problems, and suggest improvements:

        $CONTENT"
                        ;;
                    "refactor")
                        if [[ $# -eq 0 || ! -f "$1" ]]; then
                            echo "❌ Please provide a valid file to refactor"
                            exit 1
                        fi
                        FILE="$1"
                        echo "🔧 Getting refactoring suggestions from Claude..."
                        CONTENT=$(cat "$FILE")
                        claude-cli "Suggest refactoring improvements for this code to make it more readable, efficient, and maintainable. Provide the refactored version:

        $CONTENT"
                        ;;
                    *)
                        echo "❌ Unknown command: $COMMAND"
                        echo "Available commands: analyze, generate, review, refactor"
                        exit 1
                        ;;
                esac
      '';
      executable = true;
    };

    ".local/bin/ai-compare" = {
      text = ''
        #!/usr/bin/env bash
        # Compare responses from different AI models
        
        set -euo pipefail
        
        if [[ $# -eq 0 ]]; then
            echo "Usage: $0 <prompt>"
            echo "Example: $0 'Explain Python decorators'"
            exit 1
        fi
        
        PROMPT="$*"
        
        echo "🤖 Comparing AI responses for: $PROMPT"
        echo "================================================"
        
        # GitHub Copilot (if available)
        if command -v gh >/dev/null 2>&1; then
            echo "🐙 GitHub Copilot:"
            echo "-------------------"
            gh copilot suggest "$PROMPT" --type shell 2>/dev/null || echo "❌ Copilot not available"
            echo
        fi
        
        # Gemini
        if [[ -f "$HOME/.config/ai-tools/google.key" ]]; then
            echo "🔮 Google Gemini:"
            echo "------------------"
            gemini-cli "$PROMPT" 2>/dev/null || echo "❌ Gemini not available"
            echo
        fi
        
        # Claude
        if [[ -f "$HOME/.config/ai-tools/anthropic.key" ]]; then
            echo "🎭 Claude:"
            echo "-----------"
            claude-cli "$PROMPT" 2>/dev/null || echo "❌ Claude not available"
            echo
        fi
        
        # aichat (fallback)
        if command -v aichat >/dev/null 2>&1; then
            echo "💬 aichat:"
            echo "-----------"
            aichat "$PROMPT"
        fi
      '';
      executable = true;
    };

    ".local/bin/ai-models" = {
      text = ''
        #!/usr/bin/env bash
        # AI model management and testing
        
        set -euo pipefail
        
        case "''${1:-status}" in
            "status")
                echo "🤖 AI Models Status"
                echo "==================="
                
                # Check GitHub Copilot
                if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
                    echo "✅ GitHub Copilot: Available"
                else
                    echo "❌ GitHub Copilot: Not authenticated (run 'gh auth login')"
                fi
                
                # Check Gemini
                if [[ -f "$HOME/.config/ai-tools/google.key" ]]; then
                    echo "✅ Google Gemini: API key configured"
                else
                    echo "❌ Google Gemini: API key missing"
                fi
                
                # Check Claude
                if [[ -f "$HOME/.config/ai-tools/anthropic.key" ]]; then
                    echo "✅ Claude: API key configured"
                else
                    echo "❌ Claude: API key missing"
                fi
                
                # Check OpenAI
                if [[ -f "$HOME/.config/ai-tools/openai.key" ]]; then
                    echo "✅ OpenAI: API key configured"
                else
                    echo "❌ OpenAI: API key missing"
                fi
                
                # Check aichat
                if command -v aichat >/dev/null 2>&1; then
                    echo "✅ aichat: Available"
                else
                    echo "❌ aichat: Not installed"
                fi
                ;;
                
            "test")
                MODEL="''${2:-all}"
                TEST_PROMPT="Hello, please respond with 'AI model working correctly'"
                
                echo "🧪 Testing AI models..."
                
                case "$MODEL" in
                    "gemini"|"all")
                        echo "Testing Gemini..."
                        gemini-cli "$TEST_PROMPT" >/dev/null 2>&1 && echo "✅ Gemini working" || echo "❌ Gemini failed"
                        ;;
                esac
                
                case "$MODEL" in
                    "claude"|"all")
                        echo "Testing Claude..."
                        claude-cli "$TEST_PROMPT" >/dev/null 2>&1 && echo "✅ Claude working" || echo "❌ Claude failed"
                        ;;
                esac
                
                case "$MODEL" in
                    "copilot"|"all")
                        echo "Testing Copilot..."
                        gh copilot suggest "$TEST_PROMPT" --type shell >/dev/null 2>&1 && echo "✅ Copilot working" || echo "❌ Copilot failed"
                        ;;
                esac
                ;;
                
            "setup")
                echo "🔧 AI Models Setup Guide"
                echo "========================"
                echo
                echo "1. GitHub Copilot:"
                echo "   - Run: gh auth login"
                echo "   - Ensure Copilot subscription is active"
                echo
                echo "2. Google Gemini:"
                echo "   - Get API key from: https://makersuite.google.com/app/apikey"
                echo "   - Save to: ~/.config/ai-tools/google.key"
                echo
                echo "3. Claude (Anthropic):"
                echo "   - Get API key from: https://console.anthropic.com/"
                echo "   - Save to: ~/.config/ai-tools/anthropic.key"
                echo
                echo "4. OpenAI:"
                echo "   - Get API key from: https://platform.openai.com/api-keys"
                echo "   - Save to: ~/.config/ai-tools/openai.key"
                ;;
                
            *)
                echo "Usage: $0 {status|test|setup}"
                echo
                echo "Commands:"
                echo "  status  - Check which AI models are available"
                echo "  test    - Test AI model connections"
                echo "  setup   - Show setup instructions"
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
    GOOGLE_API_KEY_FILE = "$HOME/.config/ai-tools/google.key";
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
      
      # Gemini shortcuts
      gask() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: gask <question>"
          return 1
        fi
        gemini-cli "$*"
      }
      
      # Claude shortcuts  
      cask() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: cask <question>"
          return 1
        fi
        claude-cli "$*"
      }
      
      # Code explanation shortcut
      explain-cmd() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: explain-cmd <command>"
          return 1
        fi
        gh copilot explain "$*"
      }
      
      # AI model comparison
      compare-ai() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: compare-ai <question>"
          return 1
        fi
        ai-compare "$*"
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
