{ config, ... }:
{
  # Dotfiles and Configuration Management
  # Automatically manage common configuration files

  home.file = {
    # Tool configurations
    ".gitignore_global".source = ../assets/dotfiles/gitignore_global;
    ".editorconfig".source = ../assets/dotfiles/editorconfig;

    # SSH config management
    ".ssh/config".source = ../assets/dotfiles/ssh-config;

    # Hammerspoon configuration (if you have one)
    # ".hammerspoon" = {
    #   source = ../assets/hammerspoon;
    #   recursive = true;
    # };

    # Personal scripts
    ".local/bin" = {
      source = ../assets/scripts;
      recursive = true;
    };
  };

  # XDG directories for cleaner home directory
  xdg.enable = true;

  # Environment variables for XDG compliance
  home.sessionVariables = {
    # Move commonly messy configs to XDG directories
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    HISTFILE = "${config.xdg.dataHome}/zsh/history";
  };
}
