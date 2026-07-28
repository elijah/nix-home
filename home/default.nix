{ config, pkgs, lib, ... }:

{
  # Note: nixpkgs.config is handled at the nix-darwin level
  # to avoid conflicts with home-manager.useGlobalPkgs

  # https://nix-community.github.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "elw";
  home.homeDirectory = "/Users/elw";

  # Import available home configuration modules
  imports = [
    ./git.nix              # Git configuration
    ./packages.nix         # User packages
    ./shells.nix           # Shell configuration  
    ./dotfiles.nix         # Dotfiles management
    ./vscode.nix           # VS Code with Dendron and DevOps extensions
    ./emacs.nix            # Emacs with org-roam for knowledge management
    ./aws-credentials.nix  # Keep ~/.aws/credentials writable for SSO CLI tools

    # Shared home-manager modules (also imported by home/linux/default.nix -
    # these run identically on macOS and Linux). See modules/default.nix and
    # docs/ARCHITECTURE.md for the full shared-module catalog.
    ../modules/system/security.nix
    ../modules/system/backup-sync.nix
    ../modules/system/network-tools.nix
    ../modules/development/development.nix
    ../modules/development/sysadmin.nix
    # ../modules/development/data-science.nix  # disabled: heavy deps frequently fail to substitute from cache
    ../modules/development/ai-tooling.nix
    ../modules/development/mcp-dev.nix
    ../modules/development/performance-tools.nix
    ../modules/applications/knowledge-management.nix
    ../modules/applications/productivity.nix
    ../modules/applications/design-media.nix
    ../modules/applications/cloud-networking.nix
    ../modules/workflows/ai-workflows.nix
    ../modules/workflows/shell-enhancements.nix
    ../modules/workflows/org-roam-dendron.nix
  ];
}
