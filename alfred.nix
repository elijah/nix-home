{ pkgs, ... }:
let
  # Custom function to create Alfred workflow packages
  mkAlfredWorkflow = { name, src, description ? "" }: pkgs.stdenv.mkDerivation {
    inherit name src;
    
    installPhase = ''
      mkdir -p $out/Applications/Alfred.app/Contents/Frameworks/Alfred\ Framework.framework/Versions/A/Resources/workflows
      cp -r * "$out/Applications/Alfred.app/Contents/Frameworks/Alfred Framework.framework/Versions/A/Resources/workflows/"
    '';
    
    meta = {
      inherit description;
      platforms = pkgs.lib.platforms.darwin;
    };
  };

  # Alfred workflow activation script
  alfredWorkflowActivator = pkgs.writeScriptBin "alfred-activate-workflows" ''
    #!/bin/bash
    
    ALFRED_WORKFLOWS_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows"
    ASSETS_WORKFLOWS_DIR="$HOME/.config/nix-home/assets/alfred-workflows"
    
    echo "Setting up Alfred workflows..."
    
    # Create workflows directory if it doesn't exist
    mkdir -p "$ALFRED_WORKFLOWS_DIR"
    
    # Link or copy workflows from assets directory
    if [ -d "$ASSETS_WORKFLOWS_DIR" ]; then
      for workflow in "$ASSETS_WORKFLOWS_DIR"/*.alfredworkflow; do
        if [ -f "$workflow" ]; then
          workflow_name=$(basename "$workflow" .alfredworkflow)
          echo "Installing workflow: $workflow_name"
          
          # Extract workflow to temporary directory
          temp_dir=$(mktemp -d)
          unzip -q "$workflow" -d "$temp_dir"
          
          # Copy to Alfred workflows directory
          workflow_uuid=$(cat "$temp_dir/info.plist" | grep -A 1 "bundleid" | tail -1 | sed 's/.*>\(.*\)<.*/\1/' || echo "$workflow_name")
          cp -r "$temp_dir" "$ALFRED_WORKFLOWS_DIR/$workflow_uuid"
          
          rm -rf "$temp_dir"
        fi
      done
    else
      echo "No workflows directory found at $ASSETS_WORKFLOWS_DIR"
      echo "Create the directory and place .alfredworkflow files there"
    fi
    
    echo "Alfred workflows installation complete!"
  '';

in
{
  # Install utilities for Alfred workflow management
  environment.systemPackages = with pkgs; [
    # Note: Alfred itself should be installed via Mac App Store or Homebrew
    # These are utilities for workflow management
    unzip  # Required for extracting .alfredworkflow files
    jq     # Useful for JSON processing in workflows
    curl   # Common dependency for workflows
    alfredWorkflowActivator
  ];

  # Create activation script to set up workflow directories
  system.activationScripts.alfred.text = ''
    echo "Setting up Alfred workflow directories..."
    
    # Create the config directory and symlink
    mkdir -p /Users/elw/.config/nix-home
    if [ ! -L "/Users/elw/.config/nix-home/assets" ]; then
      ln -sf "/Users/elw/nix-home/assets" "/Users/elw/.config/nix-home/assets"
    fi
    
    echo "Alfred workflow setup complete!"
  '';

  # Create a system service to activate workflows on rebuild
  launchd.user.agents.alfred-workflows = {
    command = "${alfredWorkflowActivator}/bin/alfred-activate-workflows";
    serviceConfig = {
      Label = "org.nixos.alfred-workflows";
      ProgramArguments = [ "${alfredWorkflowActivator}/bin/alfred-activate-workflows" ];
      RunAtLoad = true;
      StandardOutPath = "/var/log/alfred-workflows.log";
      StandardErrorPath = "/var/log/alfred-workflows.log";
    };
  };

  # Enable Alfred in system preferences
  system.defaults = {
    LaunchServices = {
      LSQuarantine = false;  # Disable quarantine for downloaded workflows
    };
  };
}
