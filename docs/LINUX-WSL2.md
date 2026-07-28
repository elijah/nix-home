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

Every package the macOS side gets via Homebrew (see `modules/system/homebrew.nix`
and the Brewfile) is re-classified in `modules/linux/packages.nix` into three
priority tiers, applied in order by `linux-bootstrap`:

1. **`aptPackages`** — installed straight from Ubuntu 24.04's official
   `main`/`universe`/`restricted`/`multiverse` repositories via
   `apt-get install`. Preferred whenever available.
2. **`vendorRepos`** — packages that aren't in Ubuntu's own repos but do have
   a well-known, vendor-owned apt repository (Docker, GitHub CLI, HashiCorp,
   mise-en-place, NodeSource, Helm). Each entry adds the vendor's signing key
   and `sources.list.d` entry, then installs the listed packages.
3. **`homebrewFallbackPackages`** — anything left over (e.g. `awscli`, `sops`,
   assorted CLI tools whose only meaningful "official" packaging channel is a
   third-party Homebrew tap) falls back to Homebrew/Linuxbrew, matching the
   same tool by the same name as the macOS `homebrew.nix` module. If Homebrew
   isn't installed, this tier is skipped with an informational message rather
   than failing the whole bootstrap.

Every package placement was verified against a live Ubuntu 24.04 (arm64)
environment using `apt-cache policy`/`apt-get install -s` — see inline `NOTE`
comments in `packages.nix` for anything with surprising behavior (e.g. apt's
`yq` is the Python/jq-based `yq`, not `mikefarah/yq`).

`awscli` and `sops` specifically have **no** apt package and no well-known
vendor apt/PPA repo on Ubuntu 24.04, so they're classified under the Homebrew
fallback tier.

### Adding a new package

1. Check availability first: `apt-cache policy <pkg>` (inside a real or Lima
   Ubuntu 24.04 host — do this before assuming a package is apt-installable).
2. If available, add it to `aptPackages`.
3. If not, but the vendor publishes an apt/PPA repo, add a new entry to
   `vendorRepos` (or a package to an existing entry's `packages` list).
4. Otherwise, add it to `homebrewFallbackPackages`.

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

## Validated

As of this writing, the following has been confirmed working end-to-end
inside a Lima Ubuntu 24.04 (aarch64) VM:

- `nix build .#homeConfigurations.elw-linux-aarch64.activationPackage`
- `home-manager switch --flake .#elw-linux-aarch64`
- `linux-bootstrap` — apt packages, all six vendor repos (docker, github-cli,
  hashicorp, mise, nodesource, helm), and the Homebrew-fallback tier's
  graceful skip-if-brew-missing behavior.
