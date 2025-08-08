{ config, pkgs, ... }:
{
  # This module handles org-roam and Dendron integration workflows
  # The emacs overlay is already configured in the main flake.nix
  
  # Additional packages for knowledge management workflows
  environment.systemPackages = with pkgs; [
    # Org-roam dependencies are handled in the emacs module
    # Additional tools for knowledge management workflows
    pandoc          # For document conversion
    ripgrep         # Fast text search for org-roam
    fd              # Fast file finder
    sqlite          # For org-roam database
  ];

  # Environment variables for org-roam workflows
  environment.variables = {
    # Set default org-roam directory
    ORG_ROAM_DIRECTORY = "$HOME/Documents/org-roam";
  };
  
  # Note: Shell aliases would be configured in Home Manager
  # This module focuses on system-level packages and configuration
}
