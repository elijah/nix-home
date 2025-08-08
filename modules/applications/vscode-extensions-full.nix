{ pkgs, nix-vscode-extensions, ... }:

{
  programs.vscode = {
    enable = true;

    # Default profile configuration
    profiles.default = {
      extensions = with nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        # Essential Language Support
        ms-python.python
        golang.go
        hashicorp.terraform
        ms-vscode.vscode-typescript-next

        # Nix Support
        jnoortheen.nix-ide

        # GitHub Integration (avoiding GitLens)
        github.copilot
        github.copilot-chat
        github.vscode-pull-request-github
        github.vscode-github-actions

        # Docker & Containers
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers

        # Kubernetes
        ms-kubernetes-tools.vscode-kubernetes-tools
        redhat.vscode-yaml

        # Remote Development
        ms-vscode-remote.vscode-remote-extensionpack
        ms-vscode-remote.remote-ssh

        # Code Quality & Formatting
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        usernamehw.errorlens

        # Productivity Tools
        alefragnani.bookmarks
        alefragnani.project-manager
        gruntfuggly.todo-tree
        aaron-bond.better-comments

        # Markdown Support
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
        bierner.markdown-emoji

        # Knowledge Management
        dendron.dendron # Dendron knowledge management

        # File & Path Tools
        christian-kohler.path-intellisense
        christian-kohler.npm-intellisense

        # Visual Enhancements
        johnpapa.vscode-peacock
        oderwat.indent-rainbow
        mechatroner.rainbow-csv

        # Themes
        johnpapa.winteriscoming

        # Language-Specific Tools
        sumneko.lua
        shopify.ruby-lsp

        # Vim Mode
        vscodevim.vim

        # IntelliCode
        visualstudioexptteam.vscodeintellicode

        # AI Development Extensions
        continue.continue # AI code assistant
        tabnine.tabnine-vscode # TabNine AI completion
        codeium.codeium # Free AI code completion

        # API Development & Testing
        humao.rest-client # REST client for API testing
        postman.postman-for-vscode # Postman integration

        # Enhanced Documentation
        shd101wyy.markdown-preview-enhanced # Enhanced markdown preview
        mintlify.document # AI-powered documentation

        # Database & Data Tools
        ms-mssql.mssql # SQL Server support
        # oracle.oracledevtools     # Oracle database tools (not available in nix-vscode-extensions)

        # JSON & Data Processing
        quicktype.quicktype # JSON to code generation

        # Development Productivity
        # ms-vscode.vscode-json     # Enhanced JSON support (not available in nix-vscode-extensions)
        ms-vscode.hexeditor # Hex editor for binary files
      ];

      userSettings = {
        # Editor Configuration
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
          "source.fixAll.eslint" = "explicit";
        };
        "editor.rulers" = [ 80 120 ];
        "editor.minimap.enabled" = false;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;

        # Files & Auto-save
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Git Configuration
        "git.confirmSync" = false;
        "git.autofetch" = true;

        # Terminal Configuration
        "terminal.integrated.defaultProfile.osx" = "zsh";

        # Language-specific settings
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.tabSize" = 2;
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };

        # Nix IDE settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # GitHub Copilot settings
        "github.copilot.enable" = {
          "*" = true;
          "yaml" = true;
          "plaintext" = false;
          "markdown" = true;
        };

        # Error Lens settings
        "errorLens.enabledDiagnosticLevels" = [ "error" "warning" "info" ];
        "errorLens.excludeBySource" = [ "cSpell" ];

        # Todo Tree settings
        "todo-tree.regex.regex" = "((//|#|<!--|;|/\\*|^)|^\\s*(-|\\*|\\+|\\d+\\.)\\s*)\\s*($TAGS)\\s*:?";
        "todo-tree.highlights.defaultHighlight" = {
          "icon" = "alert";
          "type" = "tag";
          "foreground" = "#FFCC00";
          "background" = "#FFCC0020";
        };

        # Vim settings
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;

        # Peacock settings
        "peacock.favoriteColors" = [
          { "name" = "Angular Red"; "value" = "#dd0531"; }
          { "name" = "Azure Blue"; "value" = "#007fff"; }
          { "name" = "JavaScript Yellow"; "value" = "#f9e64f"; }
          { "name" = "Mandalorian Blue"; "value" = "#1857a4"; }
          { "name" = "Node Green"; "value" = "#215732"; }
          { "name" = "React Blue"; "value" = "#61dafb"; }
          { "name" = "Something Different"; "value" = "#832561"; }
          { "name" = "Svelte Orange"; "value" = "#ff3d00"; }
          { "name" = "Vue Green"; "value" = "#42b883"; }
        ];

        # Docker settings
        "docker.showStartPage" = false;

        # Remote development settings
        "remote.SSH.remotePlatform" = {
          "your-server" = "linux";
        };

        # Security
        "security.workspace.trust.untrustedFiles" = "open";
      };
    };
  };
}

