{ ... }:
{
  # macOS System Preferences: Dock, Finder, Trackpad, Screen Capture
  # Darwin-only: these are nix-darwin `system.defaults` options with no
  # home-manager equivalent, so this stays a nix-darwin module wired only
  # into flake.nix's darwinConfigurations.
  #
  # The cross-platform performance-monitoring packages, aliases, and
  # activation setup that used to live in this file have moved to the
  # shared home-manager module modules/development/performance-tools.nix,
  # which is imported by both home/default.nix (macOS) and
  # home/linux/default.nix (Linux).

  system.defaults = {
    # Dock optimizations
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      static-only = true;
    };

    # Finder optimizations
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    # Trackpad optimizations
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    # Energy saving
    screencapture.location = "~/Pictures/Screenshots";
  };
}
