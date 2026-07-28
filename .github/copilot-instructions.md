# Copilot Instructions for nix-home

This repository is a declarative macOS system configuration built with `nix`,
`nix-darwin`, and `home-manager`. There is no application code, tests, or
runtime to execute — changes are Nix module files evaluated by the flake, and
"correctness" means the configuration builds and evaluates cleanly.

## Build, check, and validate

The primary target user is `elw` (`aarch64-darwin`). Always use `--impure`
(the config reads `NIXPKGS_ALLOW_UNFREE=1`) and prefer `--no-update-lock-file`
for validation runs so you don't accidentally bump `flake.lock`.

```bash
# Full validation: checks module files exist, dry-run builds elw, then `nix flake check`
./scripts/validate-config.sh

# Dry-run build the primary configuration only (fast feedback loop)
NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.elw.system --dry-run --impure --no-update-lock-file

# Run a single check (e.g. just the module syntax check or format check)
NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure --no-update-lock-file  # runs all checks in flake.nix
nix-instantiate --parse ./modules/development/development.nix          # syntax-check one module file directly

# Format Nix files (nixfmt-rfc-style, enforced by the `format-check` flake check)
nix fmt

# Actually apply the configuration (only when asked to — not part of normal validation)
sudo env NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake .#elw --impure
```

`flake.nix` defines three darwin configurations sharing the same module list
except for scope: `elw` (full personal setup), `minimal` (just
`system/configuration.nix` + `development/development.nix`, for fast
iteration), and `full` (every module). The `checks` output builds all three
and runs `module-syntax`, `format-check`, and `tool-check`.

## Architecture

See `docs/ARCHITECTURE.md` for the authoritative directory map. Key points an
editor needs:

- **`modules/`** is organized by concern, not by app: `system/` (core
  nix-darwin config, Homebrew, security, performance, backup, networking),
  `development/` (languages/toolchains, sysadmin tools, AI tooling, MCP dev),
  `applications/` (desktop apps like Emacs, VS Code, productivity/design
  tools), `workflows/` (Alfred, AI-powered automation, shell enhancements,
  org-roam/Dendron). `modules/default.nix` re-exports every module path by
  category — **update it whenever you add or rename a module file**, since
  both `modules/default.nix` and the `modules` list inside each
  `darwinConfigurations.*` block in `flake.nix` must stay in sync with the
  actual files on disk (`scripts/validate-config.sh` checks a subset of these
  paths explicitly).
- **`profiles/`** are pre-built combinations of modules for specific personas
  (devops, creative, ttrpg, ai) layered on top of `profiles/default.nix`, not
  wired into `flake.nix` outputs directly — they're meant to be
  uncommented/imported manually per `docs/USAGE.md`.
- **`home/`** is the home-manager side (user-level dotfiles/shell config),
  imported into every darwin configuration via
  `home-manager.users.elw = import ./home;`.
- **`templates/module/`** is a `nix flake init` template for scaffolding new
  modules (`nix flake init --template .#module`); new modules should be moved
  into the correct `modules/<category>/` subdirectory afterward and wired into
  both `modules/default.nix` and `flake.nix`.
- **`scripts/`** holds bash tooling for the repo itself (not build outputs):
  `manage.sh` (umbrella entrypoint, e.g. `./scripts/manage.sh resync` or
  `./scripts/manage.sh skills`), `resync-environment.sh` (re-applies
  declarative state and snapshots drift into `logs/resync/<timestamp>/`),
  `validate-config.sh`, `bootstrap-agent-skills.sh` (links a shared AI agent
  skills directory into Copilot/OpenCode/Claude/Gemini/VS Code config dirs).

## Conventions

- Disabled/experimental modules are commented out in `flake.nix` with an
  inline reason rather than deleted, e.g.
  `# ./modules/development/data-science.nix  # disabled: heavy deps frequently fail to substitute from cache`.
  Preserve this pattern (comment + reason) instead of silently removing lines.
- `flake.nix`'s three configurations (`elw`, `minimal`, `full`) intentionally
  duplicate their module lists rather than composing from a shared list —
  when adding a module to `elw`/`full`, mirror the same import line in both
  blocks (grouped under the matching `# System/Development/Application/Workflow
  modules` comment) unless it's genuinely elw-specific.
- Module files are plain nix-darwin/home-manager modules (attribute sets with
  `{ pkgs, ... }: { ... }`); check a neighboring file in the same
  `modules/<category>/` directory for the expected shape before adding a new
  one.
- Secrets are handled out-of-band via `yadm` (see README.md step 6), never
  committed to this repo.
