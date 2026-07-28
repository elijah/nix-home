# Linux / WSL2 Personality

This repository primarily targets macOS via `nix-darwin`, but it also ships a
second, standalone Home Manager personality intended for a plain
**Ubuntu 24.04** userland — the expected target being a WSL2 instance on
Windows, though any Ubuntu 24.04 x86_64/aarch64 host works.

Unlike the macOS side, the Linux personality does **not** assume NixOS: it's
just Home Manager running on top of a normal Ubuntu install. That means there
is no `environment.systemPackages`-equivalent for system-level packages, so a
generated bootstrap script (`linux-bootstrap`) handles that layer instead of a
declarative Nix option.

## Directory Layout

```
modules/linux/
├── default.nix    # Module index, mirrors modules/default.nix's style
└── packages.nix   # Package classification + generated linux-bootstrap script

home/linux/
├── default.nix    # Standalone home-manager entry point (no GUI apps)
└── shells.nix     # Linux-appropriate shell/starship config

lima/
└── ubuntu-2404-wsl-test.yaml   # Lima VM template used by the test harness

scripts/
└── linux-test-harness.sh       # Wraps limactl lifecycle for local testing
```

`flake.nix` exposes this personality via `homeConfigurations`:

- `elw-linux` → `x86_64-linux`
- `elw-linux-aarch64` → `aarch64-linux`

## Package Strategy

Most of what used to live in `modules/system/homebrew.nix` (see the
Brewfile) is no longer duplicated here at all: cross-platform CLI tools with
no OS-level integration need are installed via the **shared home-manager
modules** (`modules/development/*`, `modules/system/security.nix`,
`modules/applications/*`, `modules/workflows/*` — see
`docs/ARCHITECTURE.md`'s "Shared Module Strategy" section), which are
imported by both `home/default.nix` (macOS) and `home/linux/default.nix`
(Linux) and therefore already installed via plain Nix on this personality.
`gh`, `kubernetes-helm`, `mise`, and `sops` are examples of tools that moved
this way and no longer need an apt/vendor-repo/Homebrew entry at all.

`modules/linux/packages.nix` is now reserved for the residual cases where a
shared nixpkgs package genuinely isn't the right answer: things needing real
OS-level integration (Docker Engine's daemon + systemd unit, hardware-adjacent
packages like `rtl-sdr`), or known nix build flakiness on this platform
(Node.js — "tests fail on nix-darwin", terraform/vault — build failures). It
classifies those into three priority tiers, applied in order by
`linux-bootstrap`:

1. **`aptPackages`** — installed straight from Ubuntu 24.04's official
   `main`/`universe`/`restricted`/`multiverse` repositories via
   `apt-get install`. Preferred whenever available.
2. **`vendorRepos`** — packages that aren't in Ubuntu's own repos but do have
   a well-known, vendor-owned apt repository (Docker, HashiCorp, NodeSource).
   Each entry adds the vendor's signing key and `sources.list.d` entry, then
   installs the listed packages.
3. **`homebrewFallbackPackages`** — anything left over (e.g. `awscli`,
   whose nixpkgs `awscli2` package is disabled repo-wide due to cache
   substitution failures, plus assorted CLI tools whose only meaningful
   "official" packaging channel is a third-party Homebrew tap) falls back to
   Homebrew/Linuxbrew, matching the same tool by the same name as the macOS
   `homebrew.nix` module. If Homebrew isn't installed, this tier is skipped
   with an informational message rather than failing the whole bootstrap.

Every package placement was verified against a live Ubuntu 24.04 (arm64)
environment using `apt-cache policy`/`apt-get install -s` — see inline `NOTE`
comments in `packages.nix` for anything with surprising behavior.

`awscli` specifically has **no** apt package and no well-known vendor
apt/PPA repo on Ubuntu 24.04, and its nixpkgs `awscli2` equivalent is
disabled repo-wide for cache reasons, so it's classified under the Homebrew
fallback tier.

### Adding a new package

1. **Check the shared modules first**: if it's a plain cross-platform CLI
   tool with no OS-level integration need, prefer adding it to the relevant
   shared home-manager module (`modules/development/*`,
   `modules/applications/*`, `modules/workflows/*`,
   `modules/system/security.nix`/`network-tools.nix`/`backup-sync.nix`) so
   it installs identically on both personalities - not here.
2. Only if it genuinely needs apt/vendor-repo/Homebrew (real OS integration,
   or known nix build flakiness): check availability with
   `apt-cache policy <pkg>` (inside a real or Lima Ubuntu 24.04 host — do
   this before assuming a package is apt-installable).
3. If available, add it to `aptPackages`.
4. If not, but the vendor publishes an apt/PPA repo, add a new entry to
   `vendorRepos` (or a package to an existing entry's `packages` list).
5. Otherwise, add it to `homebrewFallbackPackages`.

## Using on a Real WSL2 Machine

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/elijah/nix-home.git
cd nix-home
nix run home-manager -- switch --flake .#elw-linux   # x86_64-linux WSL2
# or .#elw-linux-aarch64 on an ARM64 host
```

Then run the generated bootstrap script (installed into your profile) to lay
down apt/vendor-repo/Homebrew packages:

```shell
linux-bootstrap
```

## Testing from macOS with Lima

Since this repo is normally developed on macOS, `scripts/linux-test-harness.sh`
spins up a disposable Ubuntu 24.04 VM via [Lima](https://lima-vm.io/) (already
a Colima/Lima dependency in the Brewfile) to exercise the Linux personality
without needing a real WSL2 box.

```shell
./scripts/linux-test-harness.sh up          # create/start the VM
./scripts/linux-test-harness.sh check       # nix build the activation package
./scripts/linux-test-harness.sh switch      # home-manager switch --flake
./scripts/linux-test-harness.sh bootstrap   # run linux-bootstrap
./scripts/linux-test-harness.sh shell       # interactive shell in the VM
./scripts/linux-test-harness.sh down        # stop (keep disk)
./scripts/linux-test-harness.sh destroy     # delete the VM entirely
```

The harness auto-detects the guest architecture (`uname -m`) and picks
`elw-linux` or `elw-linux-aarch64` accordingly, since Lima's `vz` driver runs
guests natively matching the host architecture (Apple Silicon hosts get an
`aarch64-linux` guest, not `x86_64-linux`).

### Known Lima-specific quirk

Lima names the guest account's real home directory `/home/<user>.guest`
(with a `/home/<user>.linux` convenience symlink) to avoid clashing with
mounted host paths — it does **not** use `/home/<user>` the way a real WSL2
Ubuntu install would. Since `home-manager switch` strictly requires `$HOME` to
match `home.homeDirectory` (`/home/elw`), the harness works around this two
ways:

1. The Lima template's provisioning script best-effort symlinks
   `/home/elw -> elw.guest`.
2. The harness explicitly runs `switch`/`bootstrap` with `HOME=/home/elw`
   exported.

This is purely a Lima testing artifact — a real WSL2/Ubuntu machine already
has `/home/elw` as your actual home directory, so none of this applies there.

### Disk space

The shared home-manager modules now installed on this personality include
some large packages (e.g. `python3Packages.torch`/`transformers` in
`modules/development/mcp-dev.nix`, LaTeX/PDF tooling, the
`python312Packages` data-science stack). A real WSL2 install typically has
plenty of headroom, but the Lima test VM's disk (`lima/ubuntu-2404-wsl-test.yaml`,
`disk: "60GiB"`) can be tight if the host itself is also low on space - Lima
VM disk images are files on the host filesystem, so a nearly-full host disk
can cause `switch`/`bootstrap` to fail with `Input/output error` partway
through a large download. If you hit that, check the *host's* free disk
first (`df -h /`) before assuming the Nix config itself is broken.

## Fast, VM-less Regression Checks

Most day-to-day changes don't need a full Lima run. `scripts/manage.sh check`
(and `nix flake check`) run a fast, VM-less dry-run evaluation of both
`homeConfigurations` (`elw-linux` and `elw-linux-aarch64`), which catches
eval errors, `home.*` option conflicts between modules, and packages that
aren't available on one of the two Linux architectures (e.g. `insomnia` is
missing on `aarch64-linux` — see `modules/applications/cloud-networking.nix`)
without needing a Linux builder or a VM at all. Run the Lima harness (below)
periodically for real end-to-end validation, e.g. after `nix flake update`.

## Validated

As of this writing, the following has been confirmed working end-to-end
inside a Lima Ubuntu 24.04 (aarch64) VM:

- `nix build .#homeConfigurations.elw-linux-aarch64.activationPackage`
- `home-manager switch --flake .#elw-linux-aarch64`
- `linux-bootstrap` — apt packages, all vendor repos (docker, hashicorp,
  nodesource), and the Homebrew-fallback tier's graceful
  skip-if-brew-missing behavior.

Additionally, after the shared-module refactor (see `docs/ARCHITECTURE.md`),
`nix build .#homeConfigurations.elw-linux.activationPackage --dry-run` and
`...elw-linux-aarch64.activationPackage --dry-run` were verified to evaluate
cleanly for both Linux architectures, alongside all three
`darwinConfigurations` (`elw`, `minimal`, `full`).
