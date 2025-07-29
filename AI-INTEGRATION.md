# AI Integration Quick Start Guide

This guide helps you integrate AI tools into your nix-home setup for enhanced productivity and development workflows.

## 🚀 Quick Setup

### 1. Enable AI Modules

```bash
# Enable core AI tooling
./scripts/manage-modules.sh enable ai-tooling

# Enable AI workflow automation
./scripts/manage-modules.sh enable ai-workflows

# Enable shell enhancements for better AI integration
./scripts/manage-modules.sh enable shell-enhancements

# Apply changes
./scripts/build.sh
./scripts/update.sh
```

### 2. Setup AI Environment

```bash
# Initialize AI development environment
ai-setup

# Configure API keys (optional)
mkdir -p ~/.config/ai-tools
echo "your-openai-key" > ~/.config/ai-tools/openai.key
echo "your-anthropic-key" > ~/.config/ai-tools/anthropic.key
```

## 🤖 Available AI Tools

### Command Line AI Assistance

- **`ask "question"`** - Get AI help for any question
- **`ai-commit`** - Generate intelligent commit messages
- **`ai-review`** - AI-powered code review
- **`ai-explain file.py`** - Explain code functionality
- **`ai-docs src/`** - Generate documentation

### Development Workflows

- **`ai-project-init myproject python`** - Create AI-enhanced projects
- **`smart-refactor file.js optimize`** - AI-powered refactoring
- **`ai-debug error "error message"`** - Debug with AI assistance

### Automation

- **`ai-workflow start auto-commit`** - Auto-generate commits
- **`ai-workflow start auto-docs`** - Auto-update documentation
- **`ai-workflow status`** - Check running workflows

## 🔧 VS Code Integration

The setup includes enhanced VS Code extensions:

- **GitHub Copilot** - AI code completion
- **GitHub Copilot Chat** - Interactive AI assistance
- **Continue** - Local AI code assistant
- **TabNine** - AI-powered completions

## 📚 Prompt Library

Manage reusable AI prompts:

```bash
# Add a custom prompt
prompt-library add code-review "Review this code for bugs and improvements"

# Use a saved prompt
prompt-library use code-review < mycode.py

# List all prompts
prompt-library list
```

## 🛠 Customization

### Adding Custom AI Scripts

1. Create scripts in `~/.local/bin/`
2. Use the AI environment: `source ~/.local/share/ai-venv/bin/activate`
3. Access pre-installed AI libraries (openai, anthropic, langchain)

### Workflow Automation

Configure automated workflows in `~/.config/ai-workflows/`:

```yaml
name: "Smart Backup"
trigger: "significant_changes"
threshold: 50  # lines changed
action: |
  git bundle create backup-$(date +%Y%m%d).bundle HEAD
  ai-commit
```

## 🎯 Common Use Cases

### 1. Enhanced Git Workflow
```bash
# Stage changes and get AI-generated commit
git add .
ai-commit

# Review before pushing
ai-review
```

### 2. Documentation Automation
```bash
# Auto-generate docs when code changes
ai-workflow start auto-docs

# Manual doc generation
ai-docs src/ 
```

### 3. Code Quality
```bash
# AI-powered refactoring
smart-refactor main.py optimize

# Debug assistance
ai-debug error "TypeError: 'NoneType' object is not subscriptable"
```

### 4. Project Setup
```bash
# Create AI-enhanced project
ai-project-init my-ai-app python

# Includes: AI workflows, documentation templates, and automation
```

## 📈 Advanced Features

### Integration with Just Commands

Use the included Just recipes:

```bash
# Quick AI operations
just ai-commit
just ai-review
just new-project myapp typescript
just refactor main.py performance
```

### API Integration Examples

The setup includes tools for integrating with AI APIs:

```python
# Example: Using the pre-installed environment
import openai
from langchain.llms import OpenAI

# Your AI integration code here
```

## 🔍 Troubleshooting

### Common Issues

1. **GitHub CLI not authenticated**: Run `gh auth login`
2. **AI tools not found**: Ensure modules are enabled and system rebuilt
3. **API keys not working**: Check file permissions and format

### Getting Help

```bash
# Check AI tool status
ai-workflow status

# Test AI environment
source ~/.local/share/ai-venv/bin/activate
python -c "import openai; print('AI environment ready')"

# Debug module status
./scripts/manage-modules.sh list
```

## 🌟 Tips for Maximum Productivity

1. **Use descriptive commit messages**: AI works better with context
2. **Create prompt templates**: Build a library of reusable prompts
3. **Combine tools**: Use AI workflows with shell enhancements
4. **Start small**: Enable one workflow at a time
5. **Customize prompts**: Tailor AI responses to your coding style

---

Ready to supercharge your development workflow with AI? Start with the Quick Setup above!
