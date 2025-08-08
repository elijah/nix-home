{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;  # Latest Emacs with pure GTK
    
    extraPackages = epkgs: with epkgs; [
      # Org-mode and org-roam for knowledge management
      org-roam
      org-roam-ui
      org-modern
      org-appear
      
      # Essential packages
      use-package
      which-key
      ivy
      counsel
      swiper
      company
      flycheck
      magit
      
      # Theme and UI
      doom-themes
      doom-modeline
      all-the-icons
      
      # Programming support
      lsp-mode
      lsp-ui
      
      # Nix support
      nix-mode
      
      # Note-taking enhancements
      deft
      zetteldeft
      
      # TTRPG and creative writing
      markdown-mode
      yaml-mode
      
      # Productivity
      projectile
      treemacs
    ];
  };

  # Emacs configuration
  home.file.".emacs.d/init.el".text = ''
    ;;; Emacs Configuration for DevOps and TTRPG Knowledge Management

    ;; Package management
    (require 'package)
    (setq package-enable-at-startup nil)

    ;; Use-package for clean configuration
    (unless (package-installed-p 'use-package)
      (package-refresh-contents)
      (package-install 'use-package))
    (require 'use-package)

    ;; Basic settings
    (setq inhibit-startup-message t)
    (setq ring-bell-function 'ignore)
    (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

    ;; UI improvements
    (use-package doom-themes
      :config
      (load-theme 'doom-one t))

    (use-package doom-modeline
      :init (doom-modeline-mode 1))

    (use-package all-the-icons)

    ;; Org-roam configuration for knowledge management
    (use-package org-roam
      :custom
      (org-roam-directory (file-truename "~/Documents/org-roam"))
      (org-roam-completion-everywhere t)
      :bind (("C-c n l" . org-roam-buffer-toggle)
             ("C-c n f" . org-roam-node-find)
             ("C-c n g" . org-roam-graph)
             ("C-c n i" . org-roam-node-insert)
             ("C-c n c" . org-roam-capture)
             ("C-c n j" . org-roam-dailies-capture-today))
      :config
      (org-roam-db-autosync-mode)
      
      ;; Templates for different note types
      (setq org-roam-capture-templates
            '(("d" "default" plain "%?"
               :if-new (file+head "%<%Y%m%d%H%M%S>-''${slug}.org"
                                  "#+title: ''${title}\n")
               :unnarrowed t)
              ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Notes\n\n"
               :if-new (file+head "%<%Y%m%d%H%M%S>-''${slug}.org"
                                  "#+title: ''${title}\n#+filetags: Project\n")
               :unnarrowed t)
              ("t" "ttrpg" plain "* Campaign: %?\n\n* Characters\n\n* Plot Hooks\n\n* Session Notes\n\n"
               :if-new (file+head "%<%Y%m%d%H%M%S>-''${slug}.org"
                                  "#+title: ''${title}\n#+filetags: TTRPG\n")
               :unnarrowed t))))

    ;; Org-roam UI for graph visualization
    (use-package org-roam-ui
      :after org-roam
      :config
      (setq org-roam-ui-sync-theme t
            org-roam-ui-follow t
            org-roam-ui-update-on-save t
            org-roam-ui-open-on-start t))

    ;; Enhanced org-mode appearance
    (use-package org-modern
      :hook (org-mode . org-modern-mode))

    ;; Make org elements appear when cursor is on them
    (use-package org-appear
      :hook (org-mode . org-appear-mode))

    ;; Ivy/Counsel for better completion
    (use-package ivy
      :diminish
      :bind (("C-s" . swiper))
      :config
      (ivy-mode 1))

    (use-package counsel
      :bind (("M-x" . counsel-M-x)
             ("C-x C-f" . counsel-find-file)))

    ;; Company for completion
    (use-package company
      :hook (after-init . global-company-mode))

    ;; Magit for Git integration
    (use-package magit
      :bind ("C-x g" . magit-status))

    ;; Which-key for keybinding help
    (use-package which-key
      :config
      (which-key-mode))

    ;; Projectile for project management
    (use-package projectile
      :config
      (projectile-mode +1)
      :bind-keymap
      ("C-c p" . projectile-command-map))

    ;; Nix mode for .nix files
    (use-package nix-mode
      :mode "\\.nix\\'")

    ;; Markdown mode for documentation
    (use-package markdown-mode
      :mode "\\.md\\'")

    ;; YAML mode for DevOps configs
    (use-package yaml-mode
      :mode "\\.ya?ml\\'")

    ;; Custom keybindings
    (global-set-key (kbd "C-x C-b") 'ibuffer)
    (global-set-key (kbd "C-c k") 'kill-this-buffer)
    
    ;; Enable line numbers in programming modes
    (add-hook 'prog-mode-hook 'display-line-numbers-mode)
    
    ;; Enable auto-revert for files changed outside Emacs
    (global-auto-revert-mode 1)

    ;; Create org-roam directory if it doesn't exist
    (unless (file-directory-p "~/Documents/org-roam")
      (make-directory "~/Documents/org-roam" t))

    (message "Emacs configuration loaded successfully!")
  '';

  # Environment variables for org-roam
  home.sessionVariables = {
    ORG_ROAM_DIRECTORY = "$HOME/Documents/org-roam";
  };
}
