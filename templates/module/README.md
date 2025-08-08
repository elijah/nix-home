# Module Template

This template provides a starting point for creating new nix-darwin modules.

## Usage

1. Copy this template to the appropriate module category directory:
   - `modules/system/` - System-level configuration
   - `modules/development/` - Development tools and environments
   - `modules/applications/` - Desktop applications and software
   - `modules/workflows/` - Automation and workflow enhancements

2. Rename `default.nix` to `your-module-name.nix`

3. Replace the placeholders:
   - `[REPLACE_WITH_MODULE_NAME]` - Name of your module
   - `[REPLACE_WITH_DESCRIPTION]` - Brief description of what the module does
   - `[REPLACE_WITH_CATEGORY]` - Category (system/development/applications/workflows)

4. Add your module to `modules/default.nix` in the appropriate category

5. Import your module in `flake.nix` by adding it to the desired configuration

## Best Practices

- Keep modules focused on a single responsibility
- Use descriptive names and comments
- Group related packages and configurations together
- Consider platform compatibility (macOS vs Linux)
- Test your module with `nix flake check`
