{ pkgs, ... }:
{
  # AI Workflow Automation
  # Intelligent automation for development and productivity workflows

  environment.systemPackages = with pkgs; [
    # Automation tools
    watchman # File watching and automation
    entr # File watcher for running commands
    fswatch # Cross-platform file change monitor

    # AI-enhanced development tools
    gh # GitHub CLI with Copilot integration

    # Workflow orchestration
    just # Command runner (better than make)
    direnv # Environment management per directory

    # Text processing for AI pipelines
    miller # Data processing like awk/sed/cut for CSV/JSON
    glow # Markdown renderer for AI-generated docs

    # API and webhook tools
    webhook # Lightweight webhook server

    # Notification tools
    terminal-notifier # macOS notifications from command line
  ];

  # Note: AI workflow scripts and automation are configured in Home Manager
  # This module provides the system-level packages needed for AI workflows
}
