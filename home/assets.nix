{ config, ... }:
let
  # Make symlink from source out of Nix stores
  inherit (config.lib.file) mkOutOfStoreSymlink;

  # Path to this flake checkout on the target machine. Derived from
  # home.homeDirectory (rather than hardcoded) so it resolves correctly on
  # both macOS (/Users/elw/...) and Linux/WSL2 (/home/elw/...).
  nixConfigDirectory = "${config.home.homeDirectory}/Code/GitHub/elijah/nix-home";
in
{
  # Symlink scripts directory altogether
  home.file."scripts".source = mkOutOfStoreSymlink "${nixConfigDirectory}/assets/scripts";

  # Symlink Warp workflows
  home.file.".warp".source = mkOutOfStoreSymlink "${nixConfigDirectory}/assets/.warp";
}
