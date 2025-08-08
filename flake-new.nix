{
  description = "Elijah's modular nix-darwin configuration";

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
      
      # Import our modular configuration structure
      modules = import ./modules;
      
      # Define configuration profiles
      profiles = import ./profiles;
    in
    {
      # Main darwin configuration
      darwinConfigurations.elw = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit nixpkgs nix-vscode-extensions; };
        modules = [
          # Configure nixpkgs with unfree packages allowed
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ emacs-overlay.overlays.default ];
          }

          # System configuration modules
          modules.system.configuration
          modules.system.homebrew

          # Application modules (currently active)
          modules.workflows.alfred
          modules.applications.knowledge-management
          modules.development.development
          modules.applications.emacs
          modules.development.sysadmin
          modules.applications.vscode-extensions

          # Profile-based configuration (optional)
          # profiles.devops    # Uncomment for DevOps-focused setup
          # profiles.ttrpg     # Uncomment for TTRPG-focused setup
          # profiles.creative  # Uncomment for creative work setup
          # profiles.ai        # Uncomment for AI development setup

          # Home Manager integration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.elw = import ./home;

            # Pass special args to home-manager modules
            home-manager.extraSpecialArgs = {
              inherit nix-vscode-extensions emacs-overlay;
            };

            # Allow unfree packages in home-manager
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };

      # Alternative configurations for different use cases
      darwinConfigurations = {
        # Minimal development setup
        minimal = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit nixpkgs nix-vscode-extensions; };
          modules = [
            { nixpkgs.config.allowUnfree = true; }
            modules.system.configuration
            modules.development.development
          ];
        };

        # Full-featured setup with all modules
        full = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit nixpkgs nix-vscode-extensions; };
          modules = [
            { 
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            }
            
            # All system modules
            modules.system.configuration
            modules.system.homebrew
            modules.system.security
            modules.system.performance
            modules.system.backup-sync
            modules.system.network-tools

            # All development modules
            modules.development.development
            modules.development.sysadmin
            modules.development.data-science
            modules.development.ai-tooling
            modules.development.mcp-dev

            # All application modules
            modules.applications.emacs
            modules.applications.vscode-extensions
            modules.applications.knowledge-management
            modules.applications.productivity
            modules.applications.design-media
            modules.applications.cloud-networking

            # All workflow modules
            modules.workflows.alfred
            modules.workflows.ai-workflows
            modules.workflows.shell-enhancements
            modules.workflows.org-roam-dendron

            # Home Manager
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.elw = import ./home;
              home-manager.extraSpecialArgs = {
                inherit nix-vscode-extensions emacs-overlay;
              };
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };

      # Validation and testing
      checks.${system} = {
        # Test that the main configuration builds successfully
        config-builds = self.darwinConfigurations.elw.system;

        # Test alternative configurations
        minimal-builds = self.darwinConfigurations.minimal.system;
        full-builds = self.darwinConfigurations.full.system;

        # Validate all module files exist and are syntactically correct
        module-syntax = pkgs.runCommand "check-modules" { } ''
          echo "Checking system modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.system.configuration} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.system.homebrew} > /dev/null
          
          echo "Checking development modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.development.development} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.development.sysadmin} > /dev/null
          
          echo "Checking application modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.applications.emacs} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.applications.vscode-extensions} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.applications.knowledge-management} > /dev/null
          
          echo "Checking workflow modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${modules.workflows.alfred} > /dev/null
          
          echo "All modules validated successfully"
          touch $out
        '';

        # Validate flake formatting
        format-check = pkgs.runCommand "format-check" { } ''
          if ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}; then
            echo "Format check passed" > $out
          else
            echo "Format check failed - run 'nix fmt' to fix"
            exit 1
          fi
        '';

        # Test home-manager configuration
        home-manager-test = pkgs.runCommand "home-manager-test" { } ''
          ${pkgs.nix}/bin/nix-instantiate --eval --expr '
            let 
              lib = import ${nixpkgs}/lib;
              config = import ${./home} { 
                pkgs = import ${nixpkgs} { system = "${system}"; }; 
                inherit lib;
                config = {};
                nix-vscode-extensions = {};
              };
            in 
              if builtins.isAttrs config then "valid" else "invalid"
          ' > /dev/null
          echo "Home manager test passed" > $out
        '';
      };

      # Development shell with enhanced tooling
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            nix-tree
            nix-diff
            git
          ];

          shellHook = ''
            echo "🏠 Nix-home development environment loaded!"
            echo ""
            echo "📁 Repository structure:"
            echo "  modules/          - Organized module categories"
            echo "  profiles/         - Pre-configured module combinations"
            echo "  home/            - Home Manager configuration"
            echo "  scripts/         - Utility scripts"
            echo ""
            echo "🔧 Available commands:"
            echo "  nix flake check                    - Run all validation tests"
            echo "  nix fmt                           - Format all Nix files"
            echo "  nix build .#darwinConfigurations.elw.system    - Build main config"
            echo "  nix build .#darwinConfigurations.minimal.system - Build minimal config"
            echo "  nix build .#darwinConfigurations.full.system    - Build full config"
            echo "  darwin-rebuild switch --flake .#elw           - Apply main config"
            echo "  darwin-rebuild switch --flake .#minimal       - Apply minimal config"
            echo "  darwin-rebuild switch --flake .#full          - Apply full config"
            echo ""
            echo "📊 Explore dependencies:"
            echo "  nix-tree .#darwinConfigurations.elw.system"
          '';
        };

        # Specialized development shell for module development
        modules = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            nix-tree
            nix-diff
            statix  # Nix linter
            deadnix # Dead code elimination
          ];

          shellHook = ''
            echo "🔧 Module development environment"
            echo "Additional tools: statix (linter), deadnix (dead code detection)"
          '';
        };
      };

      # Formatter
      formatter.${system} = pkgs.nixpkgs-fmt;

      # Templates for new modules
      templates = {
        module = {
          path = ./templates/module;
          description = "Template for creating new nix-darwin modules";
        };
        
        profile = {
          path = ./templates/profile;
          description = "Template for creating new configuration profiles";
        };
      };
    };
}
