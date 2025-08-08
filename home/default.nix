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
    # Complex Home Manager configurations added back incrementally
  ];
}
