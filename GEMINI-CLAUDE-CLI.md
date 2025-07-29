# Google Gemini & Claude CLI Integration

## 🎉 New AI Tools Added

Your nix-home setup now includes comprehensive CLI support for Google Gemini and Claude AI!

## 🚀 Quick Start

### 1. Enable AI Tooling

```bash
./scripts/manage-modules.sh enable ai-tooling
./scripts/build.sh && ./scripts/update.sh
```

### 2. Setup AI Environment

```bash
ai-setup  # Installs Python packages for Gemini and Claude
```

### 3. Configure API Keys

```bash
# Get your API keys:
# - Google Gemini: https://makersuite.google.com/app/apikey
# - Claude: https://console.anthropic.com/

# Save them:
echo "your-google-api-key" > ~/.config/ai-tools/google.key
echo "your-anthropic-api-key" > ~/.config/ai-tools/anthropic.key
```

### 4. Test Your Setup

```bash
ai-models status  # Check all AI models
ai-models test    # Test connections
```

## 🤖 New Commands Available

### Google Gemini

- `gemini-cli "question"` - Direct Gemini queries
- `gemini-ask` - Interactive chat session
- `gask "question"` - Quick shortcut

### Claude

- `claude-cli "question"` - Direct Claude queries
- `claude-ask` - Interactive chat session
- `claude-code analyze file.py` - Code analysis
- `claude-code generate "prompt"` - Code generation
- `claude-code review file.js` - Code review
- `cask "question"` - Quick shortcut

### Multi-Model Tools

- `ai-compare "question"` - Compare all AI responses
- `ai-models status` - Check availability
- `ai-models test` - Test connections

## 💡 Example Usage

```bash
# Compare AI responses
ai-compare "Explain Python decorators"

# Analyze code with Claude
claude-code analyze main.py

# Generate code with specific models
gemini-cli "Create a Python function to parse CSV files"
claude-cli "Write a TypeScript interface for user data"

# Interactive sessions
gemini-ask  # Chat with Gemini
claude-ask  # Chat with Claude

# Code review with Claude
claude-code review app.js
```

## 🔧 Advanced Features

### Shell Integration

- `gask` and `cask` shortcuts for quick queries
- `compare-ai` function for shell usage
- All tools integrated with your shell environment

### API Management

- Secure API key storage in `~/.config/ai-tools/`
- Automatic virtual environment management
- Error handling and fallbacks

### Code-Specific Tools

- `claude-code` suite for development tasks
- Integration with existing AI workflow tools
- Support for multiple programming languages

## 🎯 Benefits

✅ **Multiple AI Models** - Access Gemini, Claude, Copilot, and more  
✅ **Specialized Tools** - Code analysis, generation, and review  
✅ **Comparison Views** - See responses from all models at once  
✅ **Interactive Sessions** - Chat-style interfaces  
✅ **Shell Integration** - Works seamlessly with your terminal  
✅ **Secure** - Local API key management  

Your AI toolkit is now even more powerful with Google Gemini and Claude integration!
