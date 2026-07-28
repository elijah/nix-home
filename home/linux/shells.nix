{ pkgs, ... }:

{
  # Shell aliases shared across shells - Linux subset of ../shells.nix.
  # macOS-only bits (launchctl/zscaler helpers, darwin-rebuild, /opt/homebrew
  # paths) are intentionally omitted; add WSL2-specific helpers here as
  # needed (e.g. wrappers around `wsl.exe`/`explorer.exe` interop).
  home.shellAliases = {
    # Frequently used Nix scripts
    nb = "nix build";
    hmsw = "home-manager switch --flake .";
    ncg = "nix-collect-garbage -d";
    nfs = "nix flake show";

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
    zsh.enable = true;

    zsh.initContent = ''
      bindkey '^ ' autosuggest-accept
      AGKOZAK_CMD_EXEC_TIME=5
      AGKOZAK_COLORS_CMD_EXEC_TIME='yellow'
      AGKOZAK_COLORS_PROMPT_CHAR='magenta'
      AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' )
      AGKOZAK_MULTILINE=0
      AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
      export AWS_VAULT_BACKEND=file
      export AWS_VAULT_PROMPT=terminal
      export DOCKER_BUILDKIT=0
    '';

    # Style Z Shell using Starship, a cross-shell prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 1000;
        line_break.disabled = true;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        directory.truncate_to_repo = false;
        git_branch = {
          format = "[$symbol$branch]($style) ";
          symbol = " ";
        };
        nix_shell.format = " [$symbol$state]($style) ";
        docker_context.symbol = " ";
        golang.symbol = " ";
        nodejs.symbol = " ";
        python.symbol = " ";
        rust.symbol = " ";
      };
    };
  };
}
