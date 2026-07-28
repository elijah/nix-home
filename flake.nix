{
  description = "Elijah's Nix Darwin Configuration - Comprehensive Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-vscode-extensions,
      emacs-overlay,
    }:
    {
      darwinConfigurations = {
        # Primary configuration for elw user
        elw = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit nixpkgs nix-vscode-extensions; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            }

            # System modules - darwin-only (system.defaults/homebrew/nix.conf
            # options with no home-manager equivalent). Everything else that
            # used to live here has moved to shared home-manager modules,
            # imported from ./home instead - see modules/default.nix and
            # docs/ARCHITECTURE.md for the full shared-module list.
            ./modules/system/configuration.nix
            ./modules/system/homebrew.nix
            ./modules/system/performance.nix

            # Application modules - darwin-only GUI apps
            ./modules/applications/emacs.nix
            ./modules/applications/vscode-extensions.nix

            # Workflow modules - darwin-only
            ./modules/workflows/alfred.nix

            # Home Manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
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
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.elw = {
                home.stateVersion = "23.11";
                home.username = "elw";
                home.homeDirectory = "/Users/elw";
                imports = [ ./modules/development/development.nix ];
              };
            }
          ];
        };

        # Full-featured setup with all modules
        full = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit nixpkgs nix-vscode-extensions; };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            }

            # All system modules - darwin-only remainder (see elw config
            # above for why most system.* modules moved to ./home)
            ./modules/system/configuration.nix
            ./modules/system/homebrew.nix
            ./modules/system/performance.nix

            # All application modules - darwin-only GUI apps
            ./modules/applications/emacs.nix
            ./modules/applications/vscode-extensions.nix

            # All workflow modules - darwin-only
            ./modules/workflows/alfred.nix

            # Home Manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.elw = import ./home;
            }
          ];
        };
      };

      # Standalone Home Manager configurations for the Linux (Ubuntu 24.04 /
      # WSL2) personality. There is no nix-darwin/NixOS equivalent here - just
      # `home-manager.lib.homeManagerConfiguration` running on top of a plain
      # Ubuntu userland. See docs/LINUX-WSL2.md for usage and the Lima-based
      # test harness (scripts/linux-test-harness.sh) for validating this from
      # macOS without a real WSL2 machine.
      homeConfigurations =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux" # Standard WSL2 on Windows/Intel & AMD hosts
            "aarch64-linux" # WSL2 on Windows-on-ARM hosts
          ]
          (
            system:
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                config.permittedInsecurePackages = [ "electron-39.8.10" ];
              };
            in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home/linux ];
            }
          )
        // {
          # Friendly aliases matching `home-manager switch --flake .#elw-linux`
          elw-linux = self.homeConfigurations."x86_64-linux";
          elw-linux-aarch64 = self.homeConfigurations."aarch64-linux";
        };

      # Checks for validation
      checks = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (
        system:
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
            echo "Checking all modules/ .nix files..."
            find ${./modules} -name "*.nix" -type f | while read -r f; do
              echo "  parsing $f"
              ${pkgs.nix}/bin/nix-instantiate --parse "$f" > /dev/null
            done
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
          tool-check =
            pkgs.runCommand "tool-check"
              {
                buildInputs = with pkgs; [
                  git
                  nodejs
                  python3
                  ripgrep
                  bat
                  fzf
                ];
              }
              ''
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
            echo "Checking all home/ .nix files..."
            find ${./home} -name "*.nix" -type f | while read -r f; do
              echo "  parsing $f"
              ${pkgs.nix}/bin/nix-instantiate --parse "$f" > /dev/null
            done
            echo "Home Manager configuration syntax is valid"
            touch $out
          '';

          # NOTE: fast, VM-less dry-run evaluation of the Linux
          # homeConfigurations (elw-linux / elw-linux-aarch64) is NOT done
          # here as a `checks` derivation, because it needs to invoke `nix`
          # recursively against the flake itself (network + daemon access),
          # which the Nix build sandbox blocks by default. Instead it's run
          # directly on the host via `scripts/manage.sh check` (see
          # `linux-home-eval` there), which calls
          # `nix build .#homeConfigurations.<name>.activationPackage --dry-run`.
          # This still catches eval errors, option conflicts, and
          # platform-unsupported packages on every check run, without
          # needing the Lima VM harness for routine regression checks.

          # Test script validation
          script-validation =
            pkgs.runCommand "script-validation"
              {
                buildInputs = with pkgs; [ bash ];
              }
              ''
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
      devShells = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (
        system:
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
      packages = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Default package - nix-home management script
          default = pkgs.writeShellScriptBin "nix-home" ''
            ${builtins.readFile ./scripts/manage.sh}
          '';

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
