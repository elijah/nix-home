{ ... }:

{
  # Enable Homebrew
  # Note that enabling this option does not install Homebrew, see the Homebrew website for installation instructions.
  # https://brew.sh/
  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable
  homebrew.enable = true;

  # Automatically use the Brewfile that this module generates in the Nix store
  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.global.brewfile
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/services"
    "oven-sh/bun"
  ];

  # List of Homebrew formulae to install.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.brews
  homebrew.brews = [
    "bun"
    "deno"
    "volta"
    "yadm"
  ];

  # Prefer installing application from the Mac App Store
  #
  # Commented apps suffer continual update issue:
  # https://github.com/malob/nixpkgs/issues/9
  homebrew.masApps = {
    "Xcode" = 497799835;
  };


  # List of Homebrew casks to install.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.casks
  homebrew.casks = [
    "actual"
    "around"
    "cron"
    "daisydisk"
    "gitkraken"
    "gpg-suite-no-mail"
    "karabiner-elements"
    "lastpass"
    "microsoft-edge"
    "raycast"
    "rectangle"
    "spotify"
    "visual-studio-code"
    "warp"
    "zed"
    "zoom"
  ];
}
