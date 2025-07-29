{ pkgs, nix-vscode-extensions, ... }:

{
  programs.vscode = {
    enable = true;
    
    # Default profile configuration
    profiles.default = {
      extensions = with nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        # Essential Language Support
        ms-python.python
        
        # Nix Support
        jnoortheen.nix-ide
        
        # Basic Formatters
        esbenp.prettier-vscode
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
        
        # Nix IDE settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        
        # Security
        "security.workspace.trust.untrustedFiles" = "open";
      };
    };
  };
}

