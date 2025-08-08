{ pkgs, ... }:
{
  # Module Name: [REPLACE_WITH_MODULE_NAME]
  # Description: [REPLACE_WITH_DESCRIPTION]
  # Category: [system|development|applications|workflows]

  environment.systemPackages = with pkgs; [
    # Add packages here
    # example-package
  ];

  # System configuration
  # services.example-service = {
  #   enable = true;
  #   config = "example config";
  # };

  # Environment variables
  # environment.variables = {
  #   EXAMPLE_VAR = "value";
  # };

  # Activation scripts (if needed)
  # system.activationScripts.example-setup.text = ''
  #   echo "Setting up example module..."
  #   # Add setup commands here
  # '';
}
