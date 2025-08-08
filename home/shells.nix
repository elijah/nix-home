{ pkgs, ... }:

{
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.shellAliases
  # Shell aliases that is compatible across all shells
  home.shellAliases = {
    # Frequently used Nix scripts
    flakeup = "nix flake update ~/.config/nixpkgs/"; # equivalent to: nix build --recreate-lock-file
    nb = "nix build";
    sw = "./result/sw/bin/darwin-rebuild switch --flake";
    nbsw = "nb .#darwinConfigurations.elw.system && sw .#elijah";
    ncg = "nix-collect-garbage -d";
    nfs = "nix flake show";

    # Frequently used Brew commands
    bl = "brew list -1";

    # Frequently used Git commands
    gst = "git status";
    gco = "git checkout";
    gcb = "git checkout -b";
    grb = "git rebase";
    grba = "git rebase --abort";
    grbc = "git rebase --continue";
    grbi = "git rebase -i";
    gpf = "git push --force-with-lease";
    gf = "git fetch";
    gfa = "git fetch --all --prune --jobs=10";
    ggpull = "git pull origin";
    ggpush = "git push origin";
    ggfl = "git push --force-with-lease";

    # Frequently used git-crypt commands
    gcl = "git-crypt lock";
    gcu = "git-crypt unlock";
    gcs = "git-crypt status";
    gcsf = "git-crypt status -f";
  };

  programs = {
    # Note: Zsh configuration is handled at the system level via nix-darwin
    # to avoid conflicts. User-level shell customization can be added here.
    
    # Style Z Shell using Starship, a cross-shell prompt
    # https://starship.rs
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 1000;

        ## Warp compatibility
        # https://docs.warp.dev/appearance/prompt#starship-settings
        # Disable the multi-line prompt in Starship
        line_break = {
          disabled = true;
        };

        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        directory = {
          truncate_to_repo = false;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
          symbol = " ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
          symbol = "  ";
        };
        aws = {
          symbol = "  ";
        };
        package = {
          symbol = " ";
          display_private = true;
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
      };
    };
  };
}
