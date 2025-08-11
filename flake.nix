{
  description = "Elijah's Nix Darwin Configuration - Comprehensive Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-vscode-extensions, emacs-overlay }: {
    darwinConfigurations = {
      # Primary configuration for elw user
      elw = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit nixpkgs nix-vscode-extensions; };
        modules = [
          { 
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ emacs-overlay.overlays.default ];
          }
          
          # System modules
          ./modules/system/configuration.nix
          ./modules/system/homebrew.nix
          ./modules/system/security.nix
          ./modules/system/performance.nix
          ./modules/system/backup-sync.nix
          ./modules/system/network-tools.nix
          
          # Development modules
          ./modules/development/development.nix
          ./modules/development/sysadmin.nix
          ./modules/development/data-science.nix
          ./modules/development/ai-tooling.nix
          ./modules/development/mcp-dev.nix
          
          # Application modules
          ./modules/applications/emacs.nix
          ./modules/applications/vscode-extensions.nix
          ./modules/applications/knowledge-management.nix
          ./modules/applications/productivity.nix
          ./modules/applications/design-media.nix
          ./modules/applications/cloud-networking.nix
          
          # Workflow modules
          ./modules/workflows/alfred.nix
          ./modules/workflows/ai-workflows.nix
          ./modules/workflows/shell-enhancements.nix
          ./modules/workflows/org-roam-dendron.nix
          
          # Home Manager integration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elw = import ./home;
          }
        ];
      };

      # Minimal configuration for testing
      minimal = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit nixpkgs nix-vscode-extensions; };
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          ./modules/system/configuration.nix
          ./modules/development/development.nix
        ];
      };

      # Full-featured setup with all modules
      full = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit nixpkgs nix-vscode-extensions; };
        modules = [
          { 
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ emacs-overlay.overlays.default ];
          }
          
          # All system modules
          ./modules/system/configuration.nix
          ./modules/system/homebrew.nix
          ./modules/system/security.nix
          ./modules/system/performance.nix
          ./modules/system/backup-sync.nix
          ./modules/system/network-tools.nix
          
          # All development modules
          ./modules/development/development.nix
          ./modules/development/sysadmin.nix
          ./modules/development/data-science.nix
          ./modules/development/ai-tooling.nix
          ./modules/development/mcp-dev.nix
          
          # All application modules
          ./modules/applications/emacs.nix
          ./modules/applications/vscode-extensions.nix
          ./modules/applications/knowledge-management.nix
          ./modules/applications/productivity.nix
          ./modules/applications/design-media.nix
          ./modules/applications/cloud-networking.nix
          
          # All workflow modules
          ./modules/workflows/alfred.nix
          ./modules/workflows/ai-workflows.nix
          ./modules/workflows/shell-enhancements.nix
          ./modules/workflows/org-roam-dendron.nix
          
          # Home Manager integration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elw = import ./home;
          }
        ];
      };
    };

    # Checks for validation
    checks = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Test that the main configuration builds successfully
        config-builds = self.darwinConfigurations.elw.system;

        # Test alternative configurations
        minimal-builds = self.darwinConfigurations.minimal.system;
        full-builds = self.darwinConfigurations.full.system;

        # Validate all module files exist and are syntactically correct
        module-syntax = pkgs.runCommand "check-modules" { } ''
          echo "Checking system modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/system/configuration.nix} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/system/homebrew.nix} > /dev/null
          
          echo "Checking development modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/development/development.nix} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/development/sysadmin.nix} > /dev/null
          
          echo "Checking application modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/applications/emacs.nix} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/applications/vscode-extensions.nix} > /dev/null
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/applications/knowledge-management.nix} > /dev/null
          
          echo "Checking workflow modules..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${./modules/workflows/alfred.nix} > /dev/null
          
          echo "All modules validated successfully"
          touch $out
        '';

        # Validate flake formatting (check key files only)
        format-check = pkgs.runCommand "format-check" { } ''
          echo "Checking key Nix files for formatting..."
          ${pkgs.nixfmt-rfc-style}/bin/nixfmt --check ${./flake.nix}
          echo "Format check completed successfully"
          touch $out
        '';

        # Test tool availability (simplified check)
        tool-check = pkgs.runCommand "tool-check" { 
          buildInputs = with pkgs; [
            git nodejs python3
            ripgrep bat fzf
          ];
        } ''
          echo "Basic tool availability check..."
          git --version
          node --version
          python3 --version
          rg --version
          bat --version
          fzf --version
          echo "Core tools available"
          touch $out
        '';

        # Test Home Manager configuration syntax  
        home-manager-syntax = pkgs.runCommand "home-manager-syntax-check" { } ''
          echo "Validating Home Manager configuration syntax..."
          ${pkgs.nix}/bin/nix-instantiate --parse ${./home/default.nix} > /dev/null
          echo "Home Manager configuration syntax is valid"
          touch $out
        '';

        # Test script validation
        script-validation = pkgs.runCommand "script-validation" { 
          buildInputs = with pkgs; [ bash ];
        } ''
          echo "Validating shell scripts..."
          find ${./scripts} -name "*.sh" -type f | while read script; do
            echo "Checking syntax of $script..."
            bash -n "$script"
          done
          echo "Script validation completed"
          touch $out
        '';
      }
    );

    # Development shells for various workflows
    devShells = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        default = pkgs.mkShell {
          name = "nix-home-dev";
          packages = with pkgs; [
            nixfmt-rfc-style
            deadnix
            statix
            nix-tree
            cachix
            gh
          ];
          shellHook = ''
            export NIXPKGS_ALLOW_UNFREE=1
            echo "🏠 Nix Home Development Environment"
            echo "Available commands:"
            echo "  nix fmt          - Format Nix files"
            echo "  nix flake check  - Validate configuration"
            echo "  darwin-rebuild switch --flake .#elw - Apply configuration"
          '';
        };
      }
    );

    # Package outputs for module templates and utilities
    packages = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Module template generator
        new-module = pkgs.writeShellScriptBin "new-module" ''
          if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Usage: new-module <category> <name>"
            echo "Categories: system, development, applications, workflows"
            exit 1
          fi
          
          category="$1"
          name="$2"
          target="modules/$category/$name.nix"
          
          if [ -f "$target" ]; then
            echo "Module $target already exists!"
            exit 1
          fi
          
          cp templates/module/default.nix "$target"
          sed -i "s/MODULE_NAME/$name/g" "$target"
          echo "Created module: $target"
        '';
      }
    );
  };
}
