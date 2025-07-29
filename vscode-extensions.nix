{ pkgs, nix-vscode-extensions, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      # Popular extensions that could be managed through Nix
      ms-vscode.vscode-typescript-next
      ms-python.python
      rust-lang.rust-analyzer
      hashicorp.terraform
      redhat.vscode-yaml
      ms-kubernetes-tools.vscode-kubernetes-tools
      github.copilot
      github.copilot-chat
    ];
    
    userSettings = {
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.organizeImports" = true;
      };
      "files.autoSave" = "onFocusChange";
      "git.confirmSync" = false;
      "terminal.integrated.shell.osx" = "/bin/zsh";
    };
  };
}

