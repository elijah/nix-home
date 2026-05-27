#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
SNAPSHOT_DIR="${REPO_DIR}/logs/resync/${TIMESTAMP}"
UPDATE_LOCK=0
AUDIT_ONLY=0
SKIP_SWITCH=0

usage() {
  cat <<'EOF'
Usage: ./scripts/resync-environment.sh [OPTIONS]

Re-apply declarative nix-darwin + Homebrew state and snapshot package drift.

Options:
  --update-lock      Run nix flake update before rebuild
  --audit-only       Skip build/switch; only collect package snapshots and drift reports
  --skip-switch      Build config but do not switch
  --snapshot-dir DIR Write snapshots to DIR instead of logs/resync/<timestamp>
  -h, --help         Show this help
EOF
}

log() {
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo /opt/homebrew/bin/brew
    return 0
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    echo /usr/local/bin/brew
    return 0
  fi

  return 1
}

collect_brew_drift() {
  local brew_bin="$1"
  local homebrew_nix="${REPO_DIR}/modules/system/homebrew.nix"

  "$brew_bin" list --formula | sort > "${SNAPSHOT_DIR}/brew-formulae.txt"
  "$brew_bin" list --cask | sort > "${SNAPSHOT_DIR}/brew-casks.txt"
  "$brew_bin" leaves | sort > "${SNAPSHOT_DIR}/brew-leaves.txt"
  "$brew_bin" bundle dump --file "${SNAPSHOT_DIR}/Brewfile.live" --force >/dev/null

  : > "${SNAPSHOT_DIR}/declared-brews.txt"
  : > "${SNAPSHOT_DIR}/declared-casks.txt"
  awk '
    /homebrew\.brews = \[/ { in_brews=1; next }
    in_brews && /\];/ { in_brews=0; next }
    in_brews && /^[[:space:]]*"[^"]+"/ {
      line=$0
      sub(/^[[:space:]]*"/, "", line)
      sub(/".*/, "", line)
      print line
    }
  ' "$homebrew_nix" | sort > "${SNAPSHOT_DIR}/declared-brews.txt"

  awk '
    /homebrew\.casks = \[/ { in_casks=1; next }
    in_casks && /\];/ { in_casks=0; next }
    in_casks && /^[[:space:]]*"[^"]+"/ {
      line=$0
      sub(/^[[:space:]]*"/, "", line)
      sub(/".*/, "", line)
      print line
    }
  ' "$homebrew_nix" | sort > "${SNAPSHOT_DIR}/declared-casks.txt"

  comm -23 "${SNAPSHOT_DIR}/declared-brews.txt" "${SNAPSHOT_DIR}/brew-formulae.txt" > "${SNAPSHOT_DIR}/missing-declared-brews.txt" || true
  comm -13 "${SNAPSHOT_DIR}/declared-brews.txt" "${SNAPSHOT_DIR}/brew-formulae.txt" > "${SNAPSHOT_DIR}/unmanaged-brews.txt" || true
  comm -23 "${SNAPSHOT_DIR}/declared-casks.txt" "${SNAPSHOT_DIR}/brew-casks.txt" > "${SNAPSHOT_DIR}/missing-declared-casks.txt" || true
  comm -13 "${SNAPSHOT_DIR}/declared-casks.txt" "${SNAPSHOT_DIR}/brew-casks.txt" > "${SNAPSHOT_DIR}/unmanaged-casks.txt" || true
}

collect_external_snapshot() {
  if command -v pipx >/dev/null 2>&1; then
    pipx list --json > "${SNAPSHOT_DIR}/pipx.json" || true
  fi

  if command -v npm >/dev/null 2>&1; then
    npm ls -g --depth=0 --json > "${SNAPSHOT_DIR}/npm-global.json" 2>/dev/null || true
  fi

  if command -v uv >/dev/null 2>&1; then
    uv tool list > "${SNAPSHOT_DIR}/uv-tools.txt" 2>/dev/null || true
  fi

  if command -v cargo >/dev/null 2>&1; then
    cargo install --list > "${SNAPSHOT_DIR}/cargo-install.txt" 2>/dev/null || true
  fi
}

write_summary() {
  local summary_file="${SNAPSHOT_DIR}/SUMMARY.md"
  {
    echo "# Resync Summary"
    echo
    echo "- Timestamp: ${TIMESTAMP}"
    echo "- Snapshot directory: ${SNAPSHOT_DIR}"
    echo
    echo "## Homebrew Drift"
    echo
    echo "- Missing declared brews: $(wc -l < "${SNAPSHOT_DIR}/missing-declared-brews.txt" | tr -d ' ')"
    echo "- Unmanaged brews: $(wc -l < "${SNAPSHOT_DIR}/unmanaged-brews.txt" | tr -d ' ')"
    echo "- Missing declared casks: $(wc -l < "${SNAPSHOT_DIR}/missing-declared-casks.txt" | tr -d ' ')"
    echo "- Unmanaged casks: $(wc -l < "${SNAPSHOT_DIR}/unmanaged-casks.txt" | tr -d ' ')"
    echo
    echo "Review unmanaged package files to decide what should be adopted into modules/system/homebrew.nix."
  } > "$summary_file"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update-lock)
      UPDATE_LOCK=1
      shift
      ;;
    --audit-only)
      AUDIT_ONLY=1
      shift
      ;;
    --skip-switch)
      SKIP_SWITCH=1
      shift
      ;;
    --snapshot-dir)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --snapshot-dir" >&2
        exit 1
      fi
      SNAPSHOT_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

mkdir -p "$SNAPSHOT_DIR"
cd "$REPO_DIR"

log "Starting environment resync"
log "Snapshot output: ${SNAPSHOT_DIR}"

if [[ "$AUDIT_ONLY" -eq 0 ]]; then
  if [[ "$UPDATE_LOCK" -eq 1 ]]; then
    log "Updating flake.lock"
    nix flake update
  fi

  log "Building declarative system"
  NIXPKGS_ALLOW_UNFREE=1 nix build .#darwinConfigurations.elw.system --impure

  if [[ "$SKIP_SWITCH" -eq 0 ]]; then
    log "Switching to declarative system"
    ./result/sw/bin/darwin-rebuild switch --flake .#elw
  else
    log "Skipping darwin-rebuild switch (--skip-switch)"
  fi
else
  log "Audit-only mode enabled; skipping build/switch"
fi

if brew_bin="$(find_brew)"; then
  log "Collecting Homebrew snapshot and drift report"
  collect_brew_drift "$brew_bin"
else
  log "Homebrew not found; skipping Homebrew drift report"
fi

log "Collecting non-Nix package snapshots"
collect_external_snapshot

write_summary

log "Resync complete"
log "Review: ${SNAPSHOT_DIR}/SUMMARY.md"
