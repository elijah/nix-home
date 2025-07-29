{ config, pkgs, ... }:
{
  # Emacs overlay for latest Emacs and org-roam
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  home.packages = with pkgs; [
    emacs
    # Org-roam and org-roam-ui via MELPA or straight.el in Emacs config
  ];

  # Optionally, VS Code Dendron extension
  # home.packages = with pkgs; [ vscode vscode-extensions.vscode-dendron ];

  # Optionally, add org-roam-ui dependencies
  # home.packages = with pkgs; [ nodejs yarn ];

  # You may want to add a custom emacs config snippet here
}
