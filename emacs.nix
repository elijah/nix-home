{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [
      # Org-roam for knowledge management
      org-roam
      org-roam-ui
      
      # Evil mode for vim bindings
      evil
      evil-collection
      
      # Completion framework
      vertico
      marginalia
      consult
      orderless
      
      # DevOps tools
      docker
      kubernetes
      terraform-mode
      ansible
      yaml-mode
      
      # RPG/Gaming
      org-journal
      calfw
      
      # Programming
      magit
      projectile
      company
      lsp-mode
      flycheck
      
      # UI enhancements
      doom-themes
      doom-modeline
      which-key
    ];
  };
}