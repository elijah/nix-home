{ pkgs, lib, ... }:
#
# Package strategy for the Linux (Ubuntu 24.04 / WSL2) personality.
#
# This is the Linux analog of modules/system/homebrew.nix. Since there is no
# nix-darwin (and we are deliberately NOT running NixOS) on the target
# machine, "system level" tool installation can't be expressed as a
# home-manager option the way `environment.systemPackages` can on Darwin/
# NixOS - it has to be materialized as a script that shells out to apt.
#
# Preference order, per package:
#   1. `aptPackages`      - present in Ubuntu 24.04 (noble) main/universe.
#   2. `vendorRepos`      - not in Ubuntu's own repos, but the upstream
#                           vendor publishes a well-known apt repository
#                           (e.g. Docker, GitHub CLI, HashiCorp, NodeSource).
#   3. `homebrewFallback` - nothing above applies; installed via Homebrew on
#                           Linux (Linuxbrew) as a last resort, mirroring how
#                           modules/system/homebrew.nix installs these same
#                           tools on macOS.
#
# This is a skeleton/starting point, not a complete port of Brewfile: it
# demonstrates the pattern with a representative subset of packages from
# modules/system/homebrew.nix. Extend the lists below as you migrate more
# tools from the macOS Homebrew setup. Packages that are inherently
# macOS-only (sketchybar, mas, pinentry_mac, lume, m1-terraform-provider-helper,
# kanata's macOS driver, mactop) are intentionally omitted.
let
  # Packages installable straight from Ubuntu 24.04's own repositories.
  aptPackages = [
    "fzf"
    "jq"
    "yq" # NOTE: apt's `yq` is the Python/jq wrapper, not mikefarah/yq - behavior differs from Brewfile's yq
    "yamllint"
    "openssh-client"
    "openvpn"
    "pwgen"
    "pkgconf"
    "qemu-system"
    "qemu-utils"
    "librtlsdr-dev"
    "rtl-sdr"
    "gitleaks"
    "yadm"
    "zoxide"
    "pipx"
    "emacs"
  ];

  # Packages that need a vendor-owned apt repository added before `apt
  # install` can find them. Each entry is self-contained: the `setup` script
  # adds the signing key + sources.list entry, then the bootstrap script
  # installs `packages` from it.
  vendorRepos = [
    {
      name = "docker";
      description = "Docker Engine (official download.docker.com apt repo)";
      packages = [
        "docker-ce"
        "docker-ce-cli"
        "containerd.io"
        "docker-buildx-plugin"
        "docker-compose-plugin"
      ];
      setup = ''
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
          > /etc/apt/sources.list.d/docker.list
      '';
    }
    {
      name = "github-cli";
      description = "GitHub CLI (official cli.github.com apt repo)";
      packages = [ "gh" ];
      setup = ''
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
        chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
          > /etc/apt/sources.list.d/github-cli.list
      '';
    }
    {
      name = "hashicorp";
      description = "HashiCorp tools (official apt.releases.hashicorp.com repo)";
      packages = [ ]; # none installed by default - add e.g. "terraform" or "vault" as needed
      setup = ''
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/hashicorp.gpg
        echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" \
          > /etc/apt/sources.list.d/hashicorp.list
      '';
    }
    {
      name = "mise";
      description = "mise-en-place (official mise.jdx.dev apt repo)";
      packages = [ "mise" ];
      setup = ''
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://mise.jdx.dev/gpg-key.pub | gpg --batch --yes --dearmor -o /etc/apt/keyrings/mise-archive-keyring.gpg
        echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" \
          > /etc/apt/sources.list.d/mise.list
      '';
    }
    {
      name = "nodesource";
      description = "Node.js LTS (official NodeSource apt repo) - eslint/prettier install via npm afterwards";
      packages = [ "nodejs" ];
      setup = ''
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
      '';
    }
    {
      # NOTE: the old baltocdn.com/helm apt mirror is stale/deprecated - the
      # community-maintained apt repo now lives on Buildkite's package
      # registry per https://helm.sh/docs/intro/install/#from-apt-debianubuntu
      name = "helm";
      description = "Helm (community apt repo, hosted by Buildkite)";
      packages = [ "helm" ];
      setup = ''
        install -m 0755 -d /etc/apt/keyrings
        rm -f /etc/apt/sources.list.d/helm-stable-debian.list # stale filename from an older baltocdn-based setup
        curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --batch --yes --dearmor -o /etc/apt/keyrings/helm.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
          > /etc/apt/sources.list.d/helm-debian.list
      '';
    }
  ];

  # Nothing above applies - fall back to Homebrew on Linux (Linuxbrew), same
  # tools modules/system/homebrew.nix installs via Homebrew on macOS.
  homebrewFallbackPackages = [
    "awscli" # verified on Ubuntu 24.04 (noble): apt has no installation candidate at all
    "sops" # verified on Ubuntu 24.04 (noble): not present in main/universe/security
    "aws-iam-authenticator"
    "aws-vault"
    "chainguard-dev/tap/chainctl"
    "hashicorp/tap/hcp"
    "kubeshop/monokle/monokle-cli"
    "loft-sh/tap/vcluster-experimental"
    "carvel-dev/carvel/ytt"
    "siderolabs/tap/talosctl"
    "krew"
    "kubeconform"
    "kanata"
    "volta"
    "nvm"
    "tfenv"
    "rbenv"
    "ruby-build"
    "skaffold"
    "commitizen"
  ];

  vendorRepoSetupScript = lib.concatMapStrings (repo: ''
    echo "==> [vendor-repo] ${repo.name}: ${repo.description}"
    run_as_root ${lib.escapeShellArg repo.setup}
    $SUDO apt-get update
    ${lib.optionalString (repo.packages != [ ]) ''
      $SUDO apt-get install -y --no-install-recommends ${lib.concatStringsSep " " (map lib.escapeShellArg repo.packages)}
    ''}
  '') vendorRepos;

  bootstrapScript = pkgs.writeShellApplication {
    name = "linux-bootstrap";
    runtimeInputs = [
      pkgs.curl
      pkgs.gnupg
    ];
    # SC2016: the vendor-repo `setup` blocks and the Homebrew install hint
    # are intentionally passed through single-quoted so their `$(...)`
    # substitutions are deferred to the nested `run_as_root`/`bash -c`
    # invocation (or just printed verbatim as a copy-pasteable command)
    # rather than expanded by the outer shell.
    excludeShellChecks = [ "SC2016" ];
    text = ''
      set -euo pipefail

      if [[ "$(id -u)" -ne 0 ]]; then
        SUDO=sudo
      else
        SUDO=
      fi

      run_as_root() {
        if [[ -n "$SUDO" ]]; then
          $SUDO bash -c "$1"
        else
          bash -c "$1"
        fi
      }

      echo "==> Updating apt package index"
      $SUDO apt-get update

      echo "==> Installing apt packages"
      $SUDO apt-get install -y --no-install-recommends \
        ${lib.concatStringsSep " \\\n  " (map lib.escapeShellArg aptPackages)}

      ${vendorRepoSetupScript}

      echo "==> Homebrew (Linuxbrew) fallback packages"
      if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is not installed. Install it first with:"
        echo '  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        echo "Skipping ${toString (builtins.length homebrewFallbackPackages)} fallback package(s): ${lib.concatStringsSep ", " homebrewFallbackPackages}"
      else
        brew install ${lib.concatStringsSep " " (map lib.escapeShellArg homebrewFallbackPackages)}
      fi

      echo "==> Linux bootstrap complete"
    '';
  };
in
{
  # Expose the generated bootstrap script (run manually as `linux-bootstrap`,
  # since it needs interactive sudo and network access that home-manager
  # activation should not perform automatically).
  home.packages = [ bootstrapScript ];
}
