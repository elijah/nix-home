# Module index for the Linux (Ubuntu 24.04 / WSL2) personality.
# Mirrors the style of modules/default.nix. There is deliberately no
# system/, applications/, or workflows/ category here yet - only what's
# needed to stand up a working home-manager environment on plain Ubuntu
# (no nix-darwin, no NixOS). Extend as the Linux personality grows.
{
  packages = ./packages.nix;
}
