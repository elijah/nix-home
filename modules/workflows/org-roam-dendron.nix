{ pkgs, ... }:
{
  # This module handles org-roam and Dendron integration workflows
  # The emacs overlay is already configured in the main flake.nix
  # Shared home-manager module: works identically on macOS (nix-darwin) and
  # Linux (standalone home-manager).

  # Additional packages for knowledge management workflows
  home.packages = with pkgs; [
    # Org-roam dependencies are handled in the emacs module
    # Additional tools for knowledge management workflows
    pandoc          # For document conversion
    ripgrep         # Fast text search for org-roam
    fd              # Fast file finder
    sqlite          # For org-roam database
  ];

  # Note: ORG_ROAM_DIRECTORY is set in home/emacs.nix (the darwin-only
  # Emacs module that actually consumes it) - not duplicated here to avoid
  # a conflicting definition.

  # Note: Shell aliases would be configured in Home Manager
  # This module focuses on shared packages and configuration
}
