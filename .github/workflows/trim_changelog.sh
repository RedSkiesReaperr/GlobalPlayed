#!/usr/bin/env bash
# Keeps only the entry of the released version in CHANGELOG.md, because the packager publishes the whole file.
# Meant for the CI checkout only, never commit its result.
# Usage: trim_changelog.sh <tag>, with a tag like v1.6.0 or v1.6.0-beta1
set -euo pipefail

cd "$(dirname "$0")/../.."

tag="${1:-}"

if [[ ! "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)(-(alpha|beta)[0-9]+)?$ ]]; then
  echo "Invalid tag '$tag': expected vX.Y.Z, vX.Y.Z-alphaN or vX.Y.Z-betaN" >&2
  exit 1
fi

version="${BASH_REMATCH[1]}"
entry="$(awk -v header="## $version (" 'index($0, header) == 1 { keep = 1; print; next } /^## / { keep = 0 } keep' CHANGELOG.md)"

if [ -z "$entry" ]; then
  echo "No entry for version $version in CHANGELOG.md" >&2
  exit 1
fi

printf '%s\n' "$entry" > CHANGELOG.md
