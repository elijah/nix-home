{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    
    # Essential extensions for DevOps and TTRPG workflows
    extensions = with pkgs.vscode-extensions; [
      # Language Support
      ms-python.python
      golang.go
      
      # Nix Support
      jnoortheen.nix-ide
      
      # GitHub Integration
      github.copilot
      github.copilot-chat
      
      # Docker & DevOps
      ms-azuretools.vscode-docker
      
      # Productivity
      vscodevim.vim
    ];

    userSettings = {
      # Editor settings
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', Consolas, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      
      # Theme
      "workbench.colorTheme" = "GitHub Dark";
      "workbench.iconTheme" = "material-icon-theme";
      
      # Copilot settings
      "github.copilot.enable" = true;
      "github.copilot.advanced" = {
        "secret_key" = "github_copilot";
      };
      
      # Dendron settings for knowledge management
      "dendron.rootDir" = "~/Documents/dendron";
      "dendron.defaultLookupCreateBehavior" = "selection";
      
      # File associations for TTRPG and DevOps
      "files.associations" = {
        "*.yml" = "yaml";
        "*.yaml" = "yaml";
        "*.tf" = "terraform";
        "*.tfvars" = "terraform";
        "*.md" = "markdown";
      };
      
      # Terminal settings
      "terminal.integrated.shell.osx" = "/bin/zsh";
      "terminal.integrated.fontSize" = 14;
      
      # Nix IDE settings
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      
      # DevOps workflow settings
      "yaml.schemas" = {
        "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.{yml,yaml}";
        "https://json.schemastore.org/kustomization.json" = "kustomization.{yml,yaml}";
        "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" = "**/docker-compose*.{yml,yaml}";
      };
    };

    keybindings = [
      {
        key = "ctrl+shift+p";
        command = "workbench.action.showCommands";
      }
      {
        key = "ctrl+shift+`";
        command = "workbench.action.terminal.new";
      }
      # Dendron keybindings for knowledge management
      {
        key = "ctrl+l";
        command = "dendron.lookup";
      }
      {
        key = "ctrl+shift+l";
        command = "dendron.lookupSchema";
      }
    ];
  };
}
