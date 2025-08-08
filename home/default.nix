{ config, pkgs, lib, ... }:

{
  # Allow unfree packages like VSCode and its extensions
  nixpkgs.config.allowUnfree = true;

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
    # Note: VS Code extensions are now configured in the main flake via nix-darwin modules
    # Complex Home Manager configurations will be added back incrementally
  ];
}
