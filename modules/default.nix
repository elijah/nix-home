# Module index for easy importing
# This file exports all available modules organized by category.
#
# NOTE on sharing: most modules below are plain home-manager modules (using
# home.packages/home.sessionVariables/home.shellAliases/home.activation) and
# are imported directly by both home/default.nix (macOS) and
# home/linux/default.nix (Linux) - NOT wired into flake.nix's
# darwinConfigurations. Only genuinely darwin-only modules (marked below)
# are still imported directly into darwinConfigurations. See
# docs/ARCHITECTURE.md for the full rationale.
{
  # System modules - core configuration and system services
  system = {
    configuration = ./system/configuration.nix; # darwin-only: nix.conf/system.defaults/stateVersion
    homebrew = ./system/homebrew.nix; # darwin-only: Homebrew package management
    performance = ./system/performance.nix; # darwin-only: Dock/Finder/trackpad system.defaults
    security = ./system/security.nix; # shared: home-manager module
    backup-sync = ./system/backup-sync.nix; # shared: home-manager module
    network-tools = ./system/network-tools.nix; # shared: home-manager module
  };

  # Development modules - programming languages and tools (all shared)
  development = {
    development = ./development/development.nix;
    sysadmin = ./development/sysadmin.nix;
    data-science = ./development/data-science.nix; # disabled in flake.nix: heavy deps frequently fail to substitute from cache
    ai-tooling = ./development/ai-tooling.nix;
    mcp-dev = ./development/mcp-dev.nix;
    performance-tools = ./development/performance-tools.nix; # split out of system/performance.nix
  };

  # Application modules - desktop applications and user software
  applications = {
    emacs = ./applications/emacs.nix; # darwin-only: GUI app, not installed on Linux personality
    vscode-extensions = ./applications/vscode-extensions.nix; # darwin-only: GUI app, not installed on Linux personality
    knowledge-management = ./applications/knowledge-management.nix; # shared: home-manager module
    productivity = ./applications/productivity.nix; # shared: home-manager module
    design-media = ./applications/design-media.nix; # shared: home-manager module
    cloud-networking = ./applications/cloud-networking.nix; # shared: home-manager module
  };

  # Workflow modules - automation and workflow enhancement
  workflows = {
    alfred = ./workflows/alfred.nix; # darwin-only: macOS Alfred app + LaunchAgents
    ai-workflows = ./workflows/ai-workflows.nix; # shared: home-manager module
    shell-enhancements = ./workflows/shell-enhancements.nix; # shared: home-manager module
    org-roam-dendron = ./workflows/org-roam-dendron.nix; # shared: home-manager module
  };
}
