# Module index for easy importing
# This file exports all available modules organized by category
{
  # System modules - core configuration and system services
  system = {
    configuration = ./system/configuration.nix;
    homebrew = ./system/homebrew.nix;
    security = ./system/security.nix;
    performance = ./system/performance.nix;
    backup-sync = ./system/backup-sync.nix;
    network-tools = ./system/network-tools.nix;
  };

  # Development modules - programming languages and tools
  development = {
    development = ./development/development.nix;
    sysadmin = ./development/sysadmin.nix;
    data-science = ./development/data-science.nix;
    ai-tooling = ./development/ai-tooling.nix;
    mcp-dev = ./development/mcp-dev.nix;
  };

  # Application modules - desktop applications and user software
  applications = {
    emacs = ./applications/emacs.nix;
    vscode-extensions = ./applications/vscode-extensions.nix;
    knowledge-management = ./applications/knowledge-management.nix;
    productivity = ./applications/productivity.nix;
    design-media = ./applications/design-media.nix;
    cloud-networking = ./applications/cloud-networking.nix;
  };

  # Workflow modules - automation and workflow enhancement
  workflows = {
    alfred = ./workflows/alfred.nix;
    ai-workflows = ./workflows/ai-workflows.nix;
    shell-enhancements = ./workflows/shell-enhancements.nix;
    org-roam-dendron = ./workflows/org-roam-dendron.nix;
  };
}
