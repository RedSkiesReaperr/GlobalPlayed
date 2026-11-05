#!/usr/bin/env bash
# Checks that a release tag matches the version declared in the addon files.
# Usage: check_version.sh <tag>, with a tag like v1.6.0 or v1.6.0-beta1
set -euo pipefail

cd "$(dirname "$0")/../.."

tag="${1:-}"

if [[ ! "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)(-(alpha|beta)[0-9]+)?$ ]]; then
  echo "Invalid tag '$tag': expected vX.Y.Z, vX.Y.Z-alphaN or vX.Y.Z-betaN" >&2
  exit 1
fi

version="${BASH_REMATCH[1]}"
version_pattern="${version//./\\.}"
status=0

echo "Checking version $version"

if grep -Eq "^## Version: ${version_pattern}[[:space:]]*$" GlobalPlayed.toc; then
  echo "OK: GlobalPlayed.toc"
else
  echo "Missing '## Version: $version' in GlobalPlayed.toc" >&2
  status=1
fi

if grep -Eq "^## ${version_pattern} \([0-9]{4}-[0-9]{2}-[0-9]{2}\)[[:space:]]*$" CHANGELOG.md; then
  echo "OK: CHANGELOG.md"
else
  echo "Missing '## $version (YYYY-MM-DD)' in CHANGELOG.md" >&2
  status=1
fi

exit "$status"
