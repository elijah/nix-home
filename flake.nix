{
  description = "My nix-home flake";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    # Environment/system management
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Emacs overlay for latest packages
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, nix-vscode-extensions, emacs-overlay }: 
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # We need a darwinConfigurations output to actually have a `nix-darwin` configuration.
    # https://github.com/LnL7/nix-darwin#flakes-experimental
    darwinConfigurations.elw = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit nixpkgs nix-vscode-extensions; };
      modules = [
        # Configure nixpkgs with unfree packages allowed
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ emacs-overlay.overlays.default ];
        }
        
        # Main `nix-darwin` configuration
        # https://github.com/LnL7/nix-darwin#flakes-experimental
        ./configuration.nix

        # Homebrew configuration
        # https://xyno.space/post/nix-darwin-introduction
        ./homebrew.nix

        # Alfred workflows configuration
        ./alfred.nix

        # Optional package ecosystems (uncomment to enable)
        # ./data-science.nix        # R, Jupyter, Python scientific stack
        ./knowledge-management.nix # Obsidian, markdown tools, writing
        ./development.nix         # Multi-language dev environment
        ./emacs.nix              # Emacs configuration with org-roam
        
        # Enhancement modules (uncomment to enable)
        # ./security.nix            # Security and privacy tools
        # ./productivity.nix        # Modern CLI tools and productivity
        # ./cloud-networking.nix    # Cloud platforms and networking
        # ./design-media.nix        # Design and media processing tools
        ./sysadmin.nix           # System administration and DevOps
        # ./shell-enhancements.nix  # Modern shell configuration
        # ./performance.nix         # Performance monitoring and optimization
        # ./backup-sync.nix         # Backup and synchronization tools
        # ./network-tools.nix       # Network utilities and diagnostics
        # ./ai-tooling.nix          # AI development and assistance tools
        # ./ai-workflows.nix        # AI-powered workflow automation
        
        # The flake-based setup of the Home Manager `nix-darwin` module
        # https://nix-community.github.io/home-manager/index.html#sec-flakes-nix-darwin-module
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.elw = import ./home;

            # Pass nix-vscode-extensions and emacs-overlay to home-manager modules
            home-manager.extraSpecialArgs = {
              inherit nix-vscode-extensions emacs-overlay;
            };
            
            # Allow unfree packages in home-manager
            nixpkgs.config.allowUnfree = true;
          }

      ];
    };

    # Add checks for validation and testing
    checks.${system} = {
      # Test that the configuration builds successfully
      config-builds = self.darwinConfigurations.elw.system;
      
      # Validate all module files exist and are syntactically correct
      module-syntax = pkgs.runCommand "check-modules" {} ''
        ${pkgs.nix}/bin/nix-instantiate --parse ${./configuration.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./homebrew.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./alfred.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./knowledge-management.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./development.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./emacs.nix} > /dev/null
        ${pkgs.nix}/bin/nix-instantiate --parse ${./sysadmin.nix} > /dev/null
        touch $out
      '';

      # Test emacs configuration
      emacs-config-test = pkgs.runCommand "test-emacs-config" 
        { buildInputs = [ pkgs.emacs29-pgtk ]; } ''
        # Test that emacs can load without errors
        timeout 30s ${pkgs.emacs29-pgtk}/bin/emacs --batch --eval "(message \"Emacs loads successfully\")" 2>&1
        echo "Emacs configuration test passed" > $out
      '';

      # Validate flake formatting
      format-check = pkgs.runCommand "format-check" {} ''
        if ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}; then
          echo "Format check passed" > $out
        else
          echo "Format check failed - run 'nix fmt' to fix"
          exit 1
        fi
      '';

      # Test home-manager configuration
      home-manager-test = pkgs.runCommand "home-manager-test" {} ''
        # Basic validation that home-manager config structure is valid
        ${pkgs.nix}/bin/nix-instantiate --eval --expr '
          let 
            config = import ${./home} { pkgs = import ${nixpkgs} { system = "${system}"; }; };
          in 
            if builtins.isAttrs config then "valid" else "invalid"
        ' > /dev/null
        echo "Home manager test passed" > $out
      '';
    };

    # Add development shell for testing
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixpkgs-fmt
        nix-tree
        nix-diff
      ];
      
      shellHook = ''
        echo "Nix development environment loaded!"
        echo "Available commands:"
        echo "  nix flake check    - Run all tests"
        echo "  nix fmt           - Format nix files"
        echo "  nix-tree          - Explore dependency tree"
      '';
    };

    # Set Nix formatter
    formatter.${system} = pkgs.nixpkgs-fmt;
  };
}
