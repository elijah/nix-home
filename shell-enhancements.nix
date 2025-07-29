{ pkgs, ... }:
{
  # Modern Shell Enhancement
  # Supercharge your shell experience with modern tools and configurations

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    
    # Better history configuration
    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };
    
    # Modern shell options
    setopt = [
      "HIST_VERIFY"
      "SHARE_HISTORY"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_REDUCE_BLANKS"
      "INC_APPEND_HISTORY"
      "AUTO_CD"
      "GLOB_DOTS"
    ];
    
    # Enhanced completions
    completionInit = ''
      # Advanced completion system
      autoload -Uz compinit
      compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
      
      # Case insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Menu-driven completion
      zstyle ':completion:*' menu select
      
      # Colors in completion
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      
      # Better directory completion
      zstyle ':completion:*' special-dirs true
      
      # Complete process IDs for kill
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
    '';
    
    initExtra = ''
      # Load our custom functions
      fpath=(~/.local/share/zsh/functions $fpath)
      autoload -Uz ~/.local/share/zsh/functions/*
      
      # Better key bindings
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[3~' delete-char
      bindkey '^[3;5~' delete-char
      
      # Custom prompt with git integration
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f'
      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f''${vcs_info_msg_0_} %F{green}❯%f '
      
      # Smart cd that learns from your habits
      eval "$(zoxide init zsh)"
      
      # FZF integration
      if command -v fzf >/dev/null 2>&1; then
        source <(fzf --zsh)
        
        # Custom FZF functions
        fcd() {
          local dir
          dir=$(find ''${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
          cd "$dir"
        }
        
        fkill() {
          local pid
          pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
          [ -n "$pid" ] && echo "$pid" | xargs kill -''${1:-9}
        }
      fi
      
      # Enhanced aliases
      alias ll='eza -la --git --icons --group-directories-first'
      alias lt='eza --tree --level=2 --icons'
      alias cat='bat --style=auto'
      alias grep='rg'
      alias find='fd'
      alias ps='procs'
      alias top='btop'
      alias du='dust'
      alias df='duf'
      
      # Quick navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      
      # Git shortcuts (enhanced)
      alias gst='git status -sb'
      alias gd='git diff --word-diff'
      alias gds='git diff --staged'
      alias glg='git log --oneline --graph --decorate --all -20'
      alias gaa='git add -A'
      alias gcm='git commit -m'
      alias gca='git commit --amend'
      alias gpo='git push origin'
      alias gpl='git pull origin'
      alias gsw='git switch'
      alias gswc='git switch -c'
      
      # Utility functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      
      # Weather function
      weather() {
        curl -s "wttr.in/''${1:-$(curl -s ipinfo.io/city)}"
      }
      
      # Port checker
      port() {
        lsof -i :"$1"
      }
    '';
  };

  # Enhanced environment variables
  home.sessionVariables = {
    # Better defaults
    EDITOR = "code --wait";
    VISUAL = "code --wait";
    PAGER = "bat";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    
    # Development
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";
    
    # History
    HISTSIZE = "50000";
    SAVEHIST = "50000";
    HISTFILE = "$HOME/.local/share/zsh/history";
  };
}
