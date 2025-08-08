{ config, pkgs, lib, ... }:

{
  # Remove programs.emacs - that's home-manager only
  # Keep only system packages for nix-darwin
  environment.systemPackages = with pkgs; [
    emacs30-pgtk
    (emacsPackagesFor emacs30-pgtk).org-roam
    (emacsPackagesFor emacs30-pgtk).evil
    (emacsPackagesFor emacs30-pgtk).magit
    (emacsPackagesFor emacs30-pgtk).vertico
    (emacsPackagesFor emacs30-pgtk).marginalia
    (emacsPackagesFor emacs30-pgtk).consult
    (emacsPackagesFor emacs30-pgtk).orderless
    (emacsPackagesFor emacs30-pgtk).docker
    (emacsPackagesFor emacs30-pgtk).terraform-mode
    (emacsPackagesFor emacs30-pgtk).yaml-mode
    (emacsPackagesFor emacs30-pgtk).org-journal
    (emacsPackagesFor emacs30-pgtk).projectile
    (emacsPackagesFor emacs30-pgtk).company
  ];
}
