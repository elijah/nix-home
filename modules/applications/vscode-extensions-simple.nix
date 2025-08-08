{ pkgs, nix-vscode-extensions, ... }:

{
  # VS Code and related development tools
  # Extensions are configured in Home Manager

  environment.systemPackages = with pkgs; [
    # VS Code editor
    vscode

    # VS Code related tools
    nodejs # Required for many VS Code extensions
    git # Required for VS Code Git integration
  ];

  # Note: VS Code extensions and profiles are configured in Home Manager
  # This module provides the system-level VS Code package and dependencies
}
