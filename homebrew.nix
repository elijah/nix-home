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
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/services"
    "hashicorp/tap"
    "carvel-dev/carvel"
    "chainguard-dev/tap"
    "oven-sh/bun"
    "espanso/espanso"
    "loft-sh/tap"
    "chef/homebrew-chef"
    "fluxcd/tap"
    "siderolabs/tap"
    "kreuzwerker/taps"
    "kubeshop/monokle"
    "trycua/lume"
    "neved4/homebrew-tap"
    "FelixKratz/formulae"
  ];

  # List of Homebrew formulae to install.
  # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.brews
  homebrew.brews = [
    "act"
    "awscli"
    "aws-iam-authenticator"
    "aws-vault"
    "bun"
    "chainctl"
    "colima"
    "commitizen"
    "cookiecutter"
    "deno"
    "flux"
    "fzf"
    "git-delta"
    "gh"
    "hcp"
    "jj"
    "jq"
    "kanata"
    "krew"
    "lume"
    "m1-terraform-provider-helper"
    "mkcert"
    "mise"
    "monokle-cli"
    "nvm"
    "pipx"
    "pre-commit"
    "skaffold"
    "sketchybar"
    "talosctl"
    "vcluster-experimental"
    "volta"
    "wrkflw"
    "yadm"
    "ytt"
    "zoxide"
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
  # Don't install docker here or you will have a bad time in our environment...
  homebrew.casks = [
    "alfred"
    "arc"
    "around"
    "betterdisplay"
    "browser-actions"
    "daisydisk"
    "discord"
    "espanso"
    "flashspace"
    "ghostty"
    "gitkraken"
    "gpg-suite-no-mail"
    "google-chrome"
    "hammerspoon"
    "hookmark"
    "jordanbaird-ice"
    "karabiner-elements"
    "microsoft-teams"
    "notion"
    "notion-calendar"
    "obsidian"
    "positron"
    "raycast"
    "rectangle"
    "shortcat"
    "spotify"
    "visual-studio-code"
    "warp"
    "yaak"
    "zed"
    "zoom"
  ];
}
