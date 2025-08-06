{ config, pkgs, lib, ... }:

{
  # Remove programs.emacs - that's home-manager only
  # Keep only system packages for nix-darwin
  environment.systemPackages = with pkgs; [
    emacs29-pgtk
    (emacsPackagesFor emacs29-pgtk).org-roam
    (emacsPackagesFor emacs29-pgtk).evil
    (emacsPackagesFor emacs29-pgtk).magit
    (emacsPackagesFor emacs29-pgtk).vertico
    (emacsPackagesFor emacs29-pgtk).marginalia
    (emacsPackagesFor emacs29-pgtk).consult
    (emacsPackagesFor emacs29-pgtk).orderless
    (emacsPackagesFor emacs29-pgtk).docker
    (emacsPackagesFor emacs29-pgtk).terraform-mode
    (emacsPackagesFor emacs29-pgtk).yaml-mode
    (emacsPackagesFor emacs29-pgtk).org-journal
    (emacsPackagesFor emacs29-pgtk).projectile
    (emacsPackagesFor emacs29-pgtk).company
  ];
}