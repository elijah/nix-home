{ config, pkgs, lib, nix-vscode-extensions, ... }:

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

  # Only import files that actually exist - comment out missing ones
  imports = [
    # ./vscode.nix           # Create this file or comment out
    # ./shell.nix            # Create this file or comment out  
    # ./git.nix              # Create this file or comment out
    # ./assets.nix           # Create this file or comment out
    # ./packages.nix         # Create this file or comment out
    # ./shells.nix           # Create this file or comment out
    # ./dotfiles.nix         # Create this file or comment out
    ../vscode-extensions.nix # Only if this file exists
  ];
}
