#!/usr/bin/env bash
# Package each playbook as a zip that claude.ai (Customize → Skills → Add) accepts:
# the archive holds one folder, named after the skill, with SKILL.md at its root.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
dist="$root/dist"
rm -rf "$dist"
mkdir -p "$dist"

for dir in "$root"/use-cases/*/; do
  name="$(basename "$dir")"
  skill="$dir/SKILL.md"
  [[ -f "$skill" ]] || continue
  declared="$(sed -n 's/^name: *//p' "$skill" | head -1)"
  if [[ "$declared" != "$name" ]]; then
    echo "error: $skill declares name '$declared', folder is '$name'" >&2
    exit 1
  fi
  stage="$(mktemp -d)"
  mkdir -p "$stage/$name"
  cp "$skill" "$stage/$name/SKILL.md"
  # Supporting files the skill reads (templates); docs and examples stay out of the zip.
  for extra in "$dir"/*.html; do
    [[ -f "$extra" ]] && cp "$extra" "$stage/$name/"
  done
  (cd "$stage" && zip -qr "$dist/$name.zip" "$name")
  rm -rf "$stage"
  echo "built dist/$name.zip"
done
