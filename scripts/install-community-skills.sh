#!/usr/bin/env bash
set -euo pipefail

# Install and merge skills from community repos, then bootstrap universal links.
# Sources:
# - affaan-m/ECC
# - obra/superpowers
# - anthropics/knowledge-work-plugins

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/agent-skill-sources"
IMPORT_DIR="$HOME/.config/agent-skills/imports"
MERGED_DIR="$IMPORT_DIR/merged"

usage() {
  cat <<'EOF'
Usage: ./scripts/install-community-skills.sh [OPTIONS]

Downloads skills from ECC, Superpowers, and Knowledge Work Plugins,
merges them with collision-safe prefixes, and links them with
bootstrap-agent-skills.sh.

Options:
  --skip-bootstrap   Build merged skills but do not run bootstrap-agent-skills.sh
  -h, --help         Show this help
EOF
}

log() {
  printf '%s\n' "$*"
}

SKIP_BOOTSTRAP=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-bootstrap)
      SKIP_BOOTSTRAP=1
      shift
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

mkdir -p "$CACHE_DIR" "$MERGED_DIR"
cd "$CACHE_DIR"

log "Downloading repo tarballs..."
curl -L https://codeload.github.com/affaan-m/ECC/tar.gz/refs/heads/main -o ecc.tar.gz
curl -L https://codeload.github.com/obra/superpowers/tar.gz/refs/heads/main -o superpowers.tar.gz
curl -L https://codeload.github.com/anthropics/knowledge-work-plugins/tar.gz/refs/heads/main -o kwp.tar.gz

log "Extracting skills sources..."
rm -rf ECC superpowers knowledge-work-plugins
mkdir -p ECC superpowers knowledge-work-plugins

extract_ecc_skills() {
  # Primary path: focused tar extraction.
  tar -xzf ecc.tar.gz --strip-components=1 -C ECC ECC-main/skills || true

  # If tar extraction did not yield skills, fallback to sparse checkout.
  if [[ ! -d ECC/skills ]] || [[ -z "$(find ECC/skills -mindepth 1 -maxdepth 1 -type d 2>/dev/null)" ]]; then
    rm -rf ECC
    git clone --depth 1 --filter=blob:none --sparse https://github.com/affaan-m/ECC.git ECC || true
    if [[ -d ECC/.git ]]; then
      (cd ECC && git sparse-checkout set skills) || true
    fi
  fi

  if [[ ! -d ECC/skills ]] || [[ -z "$(find ECC/skills -mindepth 1 -maxdepth 1 -type d 2>/dev/null)" ]]; then
    echo "Failed to retrieve ECC skills directory" >&2
    return 1
  fi
}

extract_ecc_skills

tar -xzf superpowers.tar.gz --strip-components=1 -C superpowers superpowers-main/skills || tar -xzf superpowers.tar.gz --strip-components=1 -C superpowers superpowers-main

tar -xzf kwp.tar.gz --strip-components=1 -C knowledge-work-plugins knowledge-work-plugins-main

log "Rebuilding merged skills directory..."
find "$MERGED_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

for d in ECC/skills/*; do
  [[ -d "$d" ]] || continue
  ln -s "$(realpath "$d")" "$MERGED_DIR/ecc-$(basename "$d")"
done

for d in superpowers/skills/*; do
  [[ -d "$d" ]] || continue
  ln -s "$(realpath "$d")" "$MERGED_DIR/superpowers-$(basename "$d")"
done

for plugin in knowledge-work-plugins/*; do
  [[ -d "$plugin/skills" ]] || continue
  plugin_name="$(basename "$plugin")"
  for d in "$plugin"/skills/*; do
    [[ -d "$d" ]] || continue
    ln -s "$(realpath "$d")" "$MERGED_DIR/kwp-${plugin_name}-$(basename "$d")"
  done
done

merged_count="$(find "$MERGED_DIR" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')"
log "Merged skill directories: ${merged_count}"

if [[ "$SKIP_BOOTSTRAP" -eq 0 ]]; then
  log "Bootstrapping universal skill links..."
  "$REPO_DIR/scripts/bootstrap-agent-skills.sh" --source "$MERGED_DIR"
fi

log "Done. Merged skill source: $MERGED_DIR"
