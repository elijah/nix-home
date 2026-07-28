{ lib, ... }:

{
  # Standalone home-manager entry point for Ubuntu 24.04 (including WSL2).
  # There is no nix-darwin/NixOS underneath this - it's plain home-manager
  # running on top of a regular Ubuntu userland, wired up in flake.nix as
  # `homeConfigurations."elw-linux"` / `"elw-linux-aarch64"`.
  #
  # https://nix-community.github.io/home-manager/options.html#opt-home.stateVersion
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.username = lib.mkDefault "elw";
  home.homeDirectory = lib.mkDefault "/home/elw";

  # Reuse the modules shared with the macOS personality: these are already
  # platform-agnostic (git config, cross-platform nix packages, XDG
  # dotfiles). GUI-oriented modules (VS Code, Emacs) and the macOS-flavored
  # shells.nix are intentionally NOT imported here - see docs/LINUX-WSL2.md
  # for why and how to add them back if you want a Linux-side GUI stack.
  imports = [
    ../git.nix # Git configuration
    ../packages.nix # Cross-platform nix packages
    ../dotfiles.nix # XDG dotfiles management
    ../assets.nix # Scripts/Warp symlinks (resolved relative to $HOME/Code/GitHub/elijah/nix-home)
    ./shells.nix # Linux-appropriate shell/starship config
    ../../modules/linux/packages.nix # apt/vendor-repo/homebrew-fallback bootstrap script
  ];
}
