{ pkgs, ... }:
{
  # AI Workflow Automation
  # Intelligent automation for development and productivity workflows

  environment.systemPackages = with pkgs; [
    # Automation tools
    watchman              # File watching and automation
    entr                  # File watcher for running commands
    fswatch              # Cross-platform file change monitor
    
    # AI-enhanced development tools
    gh                   # GitHub CLI with Copilot integration
    
    # Workflow orchestration
    just                 # Command runner (better than make)
    direnv              # Environment management per directory
    
    # Text processing for AI pipelines
    miller              # Data processing like awk/sed/cut for CSV/JSON
    glow                # Markdown renderer for AI-generated docs
    
    # API and webhook tools
    webhook             # Lightweight webhook server
    
    # Notification tools
    terminal-notifier   # macOS notifications from command line
  ];

  # AI workflow scripts and automation
  home.file = {
    ".local/bin/ai-workflow" = {
      text = ''
        #!/usr/bin/env bash
        # AI workflow automation orchestrator
        
        set -euo pipefail
        
        WORKFLOW_DIR="$HOME/.config/ai-workflows"
        mkdir -p "$WORKFLOW_DIR"
        
        case "''${1:-help}" in
            "setup")
                echo "🤖 Setting up AI workflows..."
                
                # Create workflow definitions
                cat > "$WORKFLOW_DIR/auto-commit.yaml" << 'EOF'
        name: "Auto Commit with AI"
        trigger: "file_change"
        pattern: "*.py,*.js,*.ts,*.nix"
        action: |
          git add .
          ai-commit
        EOF
                
                cat > "$WORKFLOW_DIR/auto-docs.yaml" << 'EOF'
        name: "Auto Documentation"
        trigger: "file_change"
        pattern: "*.py,*.js,*.ts"
        action: |
          ai-docs "$CHANGED_FILE"
          git add docs/
        EOF
                
                cat > "$WORKFLOW_DIR/code-review.yaml" << 'EOF'
        name: "Pre-commit Review"
        trigger: "pre_commit"
        action: |
          ai-review
          echo "Review complete. Proceed with commit? (y/N)"
        EOF
                
                echo "✅ AI workflows configured"
                ;;
                
            "start")
                WORKFLOW="''${2:-auto-commit}"
                echo "🚀 Starting workflow: $WORKFLOW"
                
                case "$WORKFLOW" in
                    "auto-commit")
                        echo "👀 Watching for file changes..."
                        fswatch -o . | while read num; do
                            if git status --porcelain | grep -q '^[AM]'; then
                                echo "📝 Changes detected, generating commit..."
                                ai-commit
                            fi
                        done
                        ;;
                    "auto-docs")
                        echo "📚 Watching for code changes to update docs..."
                        fswatch --include='\.py$|\.js$|\.ts$' . | while read file; do
                            echo "📖 Updating docs for: $file"
                            ai-docs "$file"
                        done
                        ;;
                    "smart-backup")
                        echo "💾 Intelligent backup workflow..."
                        # Backup only if significant changes
                        CHANGES=$(git diff --stat | tail -1 | grep -o '[0-9]\+' | head -1 || echo "0")
                        if [[ $CHANGES -gt 10 ]]; then
                            echo "📦 Significant changes detected ($CHANGES lines), creating backup..."
                            git bundle create "backup-$(date +%Y%m%d-%H%M%S).bundle" HEAD
                        fi
                        ;;
                    *)
                        echo "❌ Unknown workflow: $WORKFLOW"
                        echo "Available: auto-commit, auto-docs, smart-backup"
                        ;;
                esac
                ;;
                
            "stop")
                echo "🛑 Stopping AI workflows..."
                pkill -f fswatch || true
                pkill -f watchman || true
                echo "✅ Workflows stopped"
                ;;
                
            "status")
                echo "📊 AI Workflow Status:"
                if pgrep -f fswatch >/dev/null; then
                    echo "✅ File watchers: Active"
                else
                    echo "❌ File watchers: Inactive"
                fi
                
                if [[ -d "$WORKFLOW_DIR" ]]; then
                    echo "📁 Configured workflows:"
                    ls -1 "$WORKFLOW_DIR"/*.yaml 2>/dev/null | xargs -I {} basename {} .yaml || echo "  None"
                fi
                ;;
                
            "help"|*)
                echo "🤖 AI Workflow Automation"
                echo
                echo "Usage: $0 {setup|start|stop|status}"
                echo
                echo "Commands:"
                echo "  setup           - Initialize AI workflow configurations"
                echo "  start <name>    - Start a specific workflow"
                echo "  stop            - Stop all running workflows"
                echo "  status          - Show workflow status"
                echo
                echo "Available workflows:"
                echo "  auto-commit     - Automatically generate commit messages"
                echo "  auto-docs       - Auto-generate documentation on code changes"
                echo "  smart-backup    - Intelligent backup based on change volume"
                ;;
        esac
      '';
      executable = true;
    };
    
    ".local/bin/ai-project-init" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered project initialization
        
        set -euo pipefail
        
        if [[ $# -eq 0 ]]; then
            echo "Usage: $0 <project_name> [project_type]"
            echo "Types: python, typescript, nix, rust, go"
            exit 1
        fi
        
        PROJECT_NAME="$1"
        PROJECT_TYPE="''${2:-python}"
        
        echo "🤖 Creating AI-enhanced project: $PROJECT_NAME ($PROJECT_TYPE)"
        
        # Create project directory
        mkdir -p "$PROJECT_NAME"
        cd "$PROJECT_NAME"
        
        # Initialize git
        git init
        
        # Create AI-generated project structure
        case "$PROJECT_TYPE" in
            "python")
                echo "🐍 Setting up Python project..."
                
                # Generate project structure with AI
                aichat "Generate a modern Python project structure for '$PROJECT_NAME' including setup.py, requirements.txt, src directory, tests, and README.md" > project_structure.md
                
                # Create basic files
                mkdir -p src tests docs
                touch src/__init__.py
                touch tests/__init__.py
                
                # AI-generated README
                aichat "Generate a comprehensive README.md for a Python project called '$PROJECT_NAME'" > README.md
                
                # AI-generated requirements
                aichat "Generate a requirements.txt for a modern Python project with common dependencies" > requirements.txt
                
                # Create .gitignore
                curl -s https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore > .gitignore
                ;;
                
            "typescript")
                echo "📜 Setting up TypeScript project..."
                
                # Generate with AI
                aichat "Generate a modern TypeScript/Node.js project structure for '$PROJECT_NAME'" > project_structure.md
                
                mkdir -p src tests dist
                
                # AI-generated package.json
                aichat "Generate a package.json for a TypeScript project called '$PROJECT_NAME' with modern dependencies" > package.json
                
                # AI-generated tsconfig.json
                aichat "Generate a tsconfig.json for a modern TypeScript project" > tsconfig.json
                
                aichat "Generate a comprehensive README.md for a TypeScript project called '$PROJECT_NAME'" > README.md
                ;;
                
            "nix")
                echo "❄️  Setting up Nix project..."
                
                aichat "Generate a Nix flake project structure for '$PROJECT_NAME'" > project_structure.md
                
                # AI-generated flake.nix
                aichat "Generate a flake.nix for a project called '$PROJECT_NAME'" > flake.nix
                
                aichat "Generate a comprehensive README.md for a Nix project called '$PROJECT_NAME'" > README.md
                ;;
                
            *)
                echo "🔧 Setting up generic project..."
                aichat "Generate a project structure for '$PROJECT_NAME' using '$PROJECT_TYPE'" > project_structure.md
                aichat "Generate a comprehensive README.md for a '$PROJECT_TYPE' project called '$PROJECT_NAME'" > README.md
                ;;
        esac
        
        # Create AI workflow configuration
        mkdir -p .ai-workflows
        cat > .ai-workflows/config.yaml << EOF
        project: $PROJECT_NAME
        type: $PROJECT_TYPE
        created: $(date)
        workflows:
          - auto-commit
          - auto-docs
          - code-review
        EOF
        
        # Initial commit with AI
        git add .
        ai-commit
        
        echo "✅ Project '$PROJECT_NAME' created successfully!"
        echo "📁 Location: $(pwd)"
        echo "🚀 Next steps:"
        echo "   cd $PROJECT_NAME"
        echo "   ai-workflow setup"
        echo "   ai-workflow start auto-commit"
      '';
      executable = true;
    };
    
    ".local/bin/smart-refactor" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered code refactoring assistant
        
        set -euo pipefail
        
        if [[ $# -eq 0 ]]; then
            echo "Usage: $0 <file> [refactor_type]"
            echo "Types: optimize, modernize, simplify, security, performance"
            exit 1
        fi
        
        FILE="$1"
        REFACTOR_TYPE="''${2:-optimize}"
        
        if [[ ! -f "$FILE" ]]; then
            echo "❌ File not found: $FILE"
            exit 1
        fi
        
        echo "🔧 AI Refactoring: $FILE ($REFACTOR_TYPE)"
        
        # Create backup
        BACKUP_FILE="$FILE.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$FILE" "$BACKUP_FILE"
        echo "💾 Backup created: $BACKUP_FILE"
        
        # Generate refactoring suggestions
        TEMP_FILE=$(mktemp)
        
        case "$REFACTOR_TYPE" in
            "optimize")
                PROMPT="Optimize this code for performance and efficiency while maintaining functionality"
                ;;
            "modernize")
                PROMPT="Modernize this code using current best practices and language features"
                ;;
            "simplify")
                PROMPT="Simplify this code to improve readability while maintaining functionality"
                ;;
            "security")
                PROMPT="Improve the security of this code by addressing potential vulnerabilities"
                ;;
            "performance")
                PROMPT="Optimize this code specifically for better performance and memory usage"
                ;;
            *)
                PROMPT="Refactor this code to improve quality and maintainability"
                ;;
        esac
        
        echo "🤖 Generating refactoring suggestions..."
        cat "$FILE" | aichat "$PROMPT. Provide only the refactored code without explanations." > "$TEMP_FILE"
        
        echo "📊 Refactoring complete. Review changes:"
        echo "----------------------------------------"
        diff -u "$FILE" "$TEMP_FILE" || true
        echo "----------------------------------------"
        
        read -p "Apply these changes? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$TEMP_FILE" "$FILE"
            echo "✅ Refactoring applied to $FILE"
            echo "💾 Original backed up to $BACKUP_FILE"
            
            # Optional: commit the refactoring
            if git rev-parse --git-dir >/dev/null 2>&1; then
                read -p "Commit refactoring? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    git add "$FILE"
                    git commit -m "refactor($REFACTOR_TYPE): $(basename "$FILE")"
                fi
            fi
        else
            rm "$TEMP_FILE"
            echo "❌ Refactoring cancelled"
        fi
      '';
      executable = true;
    };
    
    ".local/bin/ai-debug" = {
      text = ''
        #!/usr/bin/env bash
        # AI-powered debugging assistant
        
        set -euo pipefail
        
        echo "🐛 AI Debugging Assistant"
        
        case "''${1:-interactive}" in
            "error")
                if [[ $# -lt 2 ]]; then
                    echo "Usage: $0 error <error_message>"
                    exit 1
                fi
                ERROR_MSG="''${*:2}"
                echo "🔍 Analyzing error: $ERROR_MSG"
                aichat "Help me debug this error: $ERROR_MSG. Provide possible causes and solutions."
                ;;
                
            "log")
                if [[ $# -lt 2 ]]; then
                    echo "Usage: $0 log <log_file>"
                    exit 1
                fi
                LOG_FILE="$2"
                if [[ ! -f "$LOG_FILE" ]]; then
                    echo "❌ Log file not found: $LOG_FILE"
                    exit 1
                fi
                echo "📋 Analyzing log file: $LOG_FILE"
                tail -50 "$LOG_FILE" | aichat "Analyze this log output for errors, warnings, and issues. Suggest debugging steps."
                ;;
                
            "trace")
                if [[ $# -lt 2 ]]; then
                    echo "Usage: $0 trace <stack_trace>"
                    exit 1
                fi
                TRACE="''${*:2}"
                echo "🔍 Analyzing stack trace..."
                echo "$TRACE" | aichat "Help me understand this stack trace and suggest debugging approaches."
                ;;
                
            "interactive"|*)
                echo "🤖 Interactive debugging mode"
                echo "Available commands:"
                echo "  error <message>  - Analyze error message"
                echo "  log <file>       - Analyze log file"
                echo "  trace <trace>    - Analyze stack trace"
                echo
                echo "Enter your debugging query:"
                read -r QUERY
                aichat "Help me debug: $QUERY"
                ;;
        esac
      '';
      executable = true;
    };
  };

  # Just command runner configuration for AI workflows
  home.file.".local/share/just/ai.just" = {
    text = ''
      # AI workflow automation recipes
      
      # Setup AI development environment
      ai-setup:
          @echo "🤖 Setting up AI environment..."
          ai-setup
      
      # Generate commit message and commit
      ai-commit:
          @echo "🤖 AI-powered commit..."
          ai-commit
      
      # Review current changes
      ai-review:
          @echo "🤖 AI code review..."
          ai-review
      
      # Generate documentation
      ai-docs FILE:
          @echo "🤖 Generating docs for {{FILE}}..."
          ai-docs {{FILE}}
      
      # Start auto-commit workflow
      watch-commit:
          @echo "👀 Starting auto-commit workflow..."
          ai-workflow start auto-commit
      
      # Start auto-docs workflow
      watch-docs:
          @echo "📚 Starting auto-docs workflow..."
          ai-workflow start auto-docs
      
      # Initialize new AI-enhanced project
      new-project NAME TYPE="python":
          @echo "🚀 Creating new {{TYPE}} project: {{NAME}}"
          ai-project-init {{NAME}} {{TYPE}}
      
      # Run AI debugging session
      debug-error ERROR:
          @echo "🐛 Debugging error: {{ERROR}}"
          ai-debug error {{ERROR}}
      
      # Refactor file with AI
      refactor FILE TYPE="optimize":
          @echo "🔧 AI refactoring {{FILE}} ({{TYPE}})"
          smart-refactor {{FILE}} {{TYPE}}
    '';
  };

  # Enhanced shell integration
  environment.shellAliases = {
    # AI workflow shortcuts
    "ai-start" = "ai-workflow start";
    "ai-stop" = "ai-workflow stop";
    "ai-status" = "ai-workflow status";
    
    # Quick AI assistance
    "debug-this" = "ai-debug interactive";
    "refactor-this" = "smart-refactor";
    "new-ai-project" = "ai-project-init";
    
    # Development workflow
    "smart-commit" = "ai-commit";
    "smart-review" = "ai-review";
    "smart-docs" = "ai-docs";
  };
}
