{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    
    profiles.default = {
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

      # settings.json and keybindings.json are managed directly by VS Code
      # and tracked via yadm for backup. Do not add userSettings or keybindings
      # here or home-manager will replace them with read-only nix store symlinks.
    };
  };
}
