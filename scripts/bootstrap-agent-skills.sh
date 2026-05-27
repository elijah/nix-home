#!/usr/bin/env bash
set -euo pipefail

SKILLS_HOME_DEFAULT="${HOME}/.config/agent-skills"
SKILLS_HOME="$SKILLS_HOME_DEFAULT"
SKILLS_SOURCE_DIR=""
SKILLS_REPO_URL=""
SKILLS_REPO_REF="main"

usage() {
  cat <<'EOF'
Usage: ./scripts/bootstrap-agent-skills.sh [OPTIONS]

Create one shared skills directory and link it to multiple agent-specific paths.

Options:
  --skills-home DIR   Shared home for skills (default: ~/.config/agent-skills)
  --source DIR        Local skills directory to sync into shared storage
  --repo URL          Git repository containing skills to clone/pull
  --ref REF           Branch/tag for --repo (default: main)
  -h, --help          Show this help

Examples:
  ./scripts/bootstrap-agent-skills.sh
  ./scripts/bootstrap-agent-skills.sh --source ~/dotfiles/skills
  ./scripts/bootstrap-agent-skills.sh --repo https://github.com/acme/agent-skills.git --ref main
EOF
}

log() {
  printf '%s\n' "$*"
}

backup_if_needed() {
  local target="$1"
  if [[ -L "$target" ]]; then
    return 0
  fi

  if [[ -e "$target" ]]; then
    local backup_path="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$target" "$backup_path"
    log "Backed up existing path: ${target} -> ${backup_path}"
  fi
}

sync_from_source() {
  local source_dir="$1"
  local dest_dir="$2"

  mkdir -p "$dest_dir"
  if command -v rsync >/dev/null 2>&1; then
    if ! rsync -a --delete --exclude '.git/' "${source_dir}/" "${dest_dir}/"; then
      log "rsync failed; falling back to cp-based sync"
      find "$dest_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
      cp -R "${source_dir}/." "${dest_dir}/"
    fi
  else
    find "$dest_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    cp -R "${source_dir}/." "${dest_dir}/"
  fi
  log "Synced local skills from ${source_dir}"
}

sync_from_repo() {
  local repo_url="$1"
  local repo_ref="$2"
  local repo_dir="$3"
  local dest_dir="$4"

  if [[ -d "$repo_dir/.git" ]]; then
    git -C "$repo_dir" fetch --all --tags --prune
    git -C "$repo_dir" checkout "$repo_ref"
    git -C "$repo_dir" pull --ff-only
  else
    git clone --branch "$repo_ref" "$repo_url" "$repo_dir"
  fi

  if [[ -d "$repo_dir/skills" ]]; then
    sync_from_source "$repo_dir/skills" "$dest_dir"
  else
    sync_from_source "$repo_dir" "$dest_dir"
  fi
}

link_target() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  backup_if_needed "$target"
  ln -sfn "$source" "$target"
  log "Linked ${target} -> ${source}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills-home)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --skills-home" >&2
        exit 1
      fi
      SKILLS_HOME="$2"
      shift 2
      ;;
    --source)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --source" >&2
        exit 1
      fi
      SKILLS_SOURCE_DIR="$2"
      shift 2
      ;;
    --repo)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --repo" >&2
        exit 1
      fi
      SKILLS_REPO_URL="$2"
      shift 2
      ;;
    --ref)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --ref" >&2
        exit 1
      fi
      SKILLS_REPO_REF="$2"
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

SHARED_SKILLS_DIR="${SKILLS_HOME}/skills"
REPO_CACHE_DIR="${SKILLS_HOME}/repo-cache"

mkdir -p "$SHARED_SKILLS_DIR"

if [[ -n "$SKILLS_SOURCE_DIR" ]]; then
  if [[ ! -d "$SKILLS_SOURCE_DIR" ]]; then
    echo "Source directory does not exist: ${SKILLS_SOURCE_DIR}" >&2
    exit 1
  fi
  sync_from_source "$SKILLS_SOURCE_DIR" "$SHARED_SKILLS_DIR"
fi

if [[ -n "$SKILLS_REPO_URL" ]]; then
  sync_from_repo "$SKILLS_REPO_URL" "$SKILLS_REPO_REF" "$REPO_CACHE_DIR" "$SHARED_SKILLS_DIR"
fi

TARGETS=(
  "${HOME}/.copilot/skills"
  "${HOME}/.claude/skills"
  "${HOME}/.gemini/skills"
  "${HOME}/.config/opencode/skills"
  "${HOME}/Library/Application Support/Code/User/prompts/skills"
)

for target in "${TARGETS[@]}"; do
  link_target "$SHARED_SKILLS_DIR" "$target"
done

mkdir -p "${SKILLS_HOME}"
cat > "${SKILLS_HOME}/README.txt" <<EOF
Shared skills home: ${SKILLS_HOME}
Shared skills dir: ${SHARED_SKILLS_DIR}

To update shared skills:
  1) Re-run bootstrap-agent-skills.sh with --source or --repo
  2) All linked agents will see updates automatically
EOF

log "Agent skill bootstrap complete"
log "Shared skills directory: ${SHARED_SKILLS_DIR}"
