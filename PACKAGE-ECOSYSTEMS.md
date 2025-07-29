# Package Ecosystem Modules

This directory contains optional Nix modules for different package ecosystems. Each module can be enabled by uncommenting it in `flake.nix`.

## Available Modules

### 🔬 Data Science (`data-science.nix`)

**What it includes:**

- **R Environment**: R language with common packages and proper library setup
- **Jupyter Ecosystem**: Complete Jupyter Lab with Python, Go, and Ruby kernels
- **Python Scientific Stack**: pandas, numpy, matplotlib, seaborn, scikit-learn, plotly
- **Data Tools**: jq, yq, csvkit for data processing
- **Visualization**: gnuplot, graphviz for creating charts and diagrams

**Perfect for:**

- Statistical analysis and research
- Data visualization and reporting
- Jupyter notebook-based workflows
- Scientific computing

### 📝 Knowledge Management (`knowledge-management.nix`)

**What it includes:**

- **Obsidian**: Your favorite knowledge management app (works with Shimmering Obsidian workflow!)
- **Markdown Tools**: LSP servers, pandoc for document conversion
- **Writing Apps**: Zettlr, Logseq for note-taking
- **Document Processing**: Typst (modern LaTeX), full TeXLive distribution
- **Text Tools**: ripgrep, fd, bat, fzf for searching and processing
- **Editors**: Neovim with modern text processing tools

**Perfect for:**

- Personal knowledge management
- Academic writing and research
- Documentation and note-taking
- Content creation

### 💻 Development (`development.nix`)

**What it includes:**

- **Multiple Languages**: Node.js, Rust, Go, Python, Ruby
- **Package Managers**: npm, yarn, bun, cargo, pip, poetry, bundler
- **Development Tools**: Git tools, formatters, linters, type checkers
- **Databases**: SQLite, PostgreSQL, MySQL clients
- **API Tools**: httpie, curl, Postman for web development
- **Container Tools**: Docker, docker-compose, Kubernetes helm
- **Editors**: VSCode (already configured), Emacs, Vim

**Perfect for:**

- Multi-language software development
- Web development and APIs
- Container-based development
- Open source contributions

## How to Enable

1. **Choose modules** you want from the list above
2. **Edit flake.nix** and uncomment the desired modules:

   ```nix
   # Uncomment any of these lines:
   ./data-science.nix        # R, Jupyter, Python scientific stack
   ./knowledge-management.nix # Obsidian, markdown tools, writing
   ./development.nix         # Multi-language dev environment
   ```

3. **Rebuild your system**:

   ```bash
   darwin-rebuild switch --flake .#elw
   ```

## Directory Structure Created

Each module creates organized directory structures:

- **Data Science**: `~/Development/data-analysis/`, R libraries in `~/.local/lib/R/`
- **Knowledge Management**: `~/Documents/{Knowledge,Notes,Research}/`
- **Development**: `~/Development/{projects,experiments,learning}/`, language-specific dirs

## Integration with Existing Setup

These modules work seamlessly with your current configuration:

- **Obsidian** integrates with your Shimmering Obsidian Alfred workflow
- **Development tools** complement your existing VSCode setup
- **All tools** respect your existing environment and don't conflict

## Customization

Each module can be customized by editing the respective `.nix` file. You can:

- Add/remove packages from the lists
- Modify environment variables
- Change directory structures
- Add custom activation scripts

## Examples of What You Can Do

- **With Data Science**: Run Jupyter notebooks with R and Python, create beautiful visualizations
- **With Knowledge Management**: Sync Obsidian with your Alfred workflows, export notes to multiple formats
- **With Development**: Build projects in multiple languages, all managed by Nix for reproducible environments

Choose the modules that match your workflow and interests!
