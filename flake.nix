{
  description = "My nix-home flake";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    # Environment/system management
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-vscode-extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

  };

  outputs = { self, nixpkgs, darwin, home-manager, nix-vscode-extensions }: {

    # We need a darwinConfigurations output to actually have a `nix-darwin` configuration.
    # https://github.com/LnL7/nix-darwin#flakes-experimental
    darwinConfigurations.elw = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
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
        # ./knowledge-management.nix # Obsidian, markdown tools, writing
        # ./development.nix         # Multi-language dev environment
        
        # The flake-based setup of the Home Manager `nix-darwin` module
        # https://nix-community.github.io/home-manager/index.html#sec-flakes-nix-darwin-module
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.elw = import ./home;

            # Pass nix-vscode-extensions to home-manager modules
            home-manager.extraSpecialArgs = {
              inherit nix-vscode-extensions;
            };
          }

      ];
    };

    # Set Nix formatter
    # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-fmt#examples
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
  };
}
