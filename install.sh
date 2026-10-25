#!/usr/bin/env bash
set -euo pipefail

skill_name='mark-cie-papers'
source_url='https://raw.githubusercontent.com/rogeryeoh49-bot/cie-paper-marking-skill/main/mark-cie-papers'
skills_dir="${CODEX_HOME:-$HOME/.codex}/skills"

if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help)
      printf 'Install CIE Paper Marking Skill into ${CODEX_HOME:-$HOME/.codex}/skills.\nExisting installations are backed up before replacement.\n'
      exit 0
      ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
fi

for command_name in curl mktemp mkdir cp mv rm; do
  command -v "$command_name" >/dev/null 2>&1 || {
    printf 'Required command is missing: %s\n' "$command_name" >&2
    exit 1
  }
done

download_dir=$(mktemp -d "${TMPDIR:-/tmp}/cie-paper-download.XXXXXX")
stage_dir=''
backup_dir=''
installed=0
destination="$skills_dir/$skill_name"

cleanup() {
  local status=$?
  trap - EXIT
  if [[ -n "$backup_dir" && -d "$backup_dir/$skill_name" && "$installed" -eq 0 && ! -e "$destination" && ! -L "$destination" ]]; then
    mv "$backup_dir/$skill_name" "$destination" || printf 'Restore the previous installation from %s\n' "$backup_dir" >&2
  fi
  [[ -z "$stage_dir" ]] || rm -rf "$stage_dir"
  rm -rf "$download_dir"
  exit "$status"
}
trap cleanup EXIT

mkdir -p "$download_dir/$skill_name/agents"
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
  "$source_url/SKILL.md" -o "$download_dir/$skill_name/SKILL.md"
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
  "$source_url/agents/openai.yaml" -o "$download_dir/$skill_name/agents/openai.yaml"

[[ -s "$download_dir/$skill_name/SKILL.md" && -s "$download_dir/$skill_name/agents/openai.yaml" ]] || {
  printf 'Downloaded skill files are empty; installation cancelled.\n' >&2
  exit 1
}
if ! /usr/bin/grep -qx 'name: mark-cie-papers' "$download_dir/$skill_name/SKILL.md"; then
  printf 'Downloaded SKILL.md has unexpected metadata; installation cancelled.\n' >&2
  exit 1
fi

mkdir -p "$skills_dir"
stage_dir=$(mktemp -d "$skills_dir/.cie-paper-stage.XXXXXX")
cp -R "$download_dir/$skill_name" "$stage_dir/$skill_name"

if [[ -e "$destination" || -L "$destination" ]]; then
  mkdir -p "${CODEX_HOME:-$HOME/.codex}/skill-backups"
  backup_dir=$(mktemp -d "${CODEX_HOME:-$HOME/.codex}/skill-backups/cie-paper.XXXXXX")
  mv "$destination" "$backup_dir/$skill_name"
fi

mv "$stage_dir/$skill_name" "$destination"
installed=1
printf 'Installed CIE Paper Marking Skill: %s\n' "$destination"
[[ -z "$backup_dir" ]] || printf 'Previous installation backed up: %s/%s\n' "$backup_dir" "$skill_name"
printf 'Start a new Codex session, then invoke $mark-cie-papers.\n'
