#!/bin/bash

# Extract version from GitHub Actions environment
VERSION=${VERSION}

echo "🔍 Checking version consistency: $VERSION"

# List of files where the version should be present
FILES_TO_CHECK=(
  "GlobalPlayed/GlobalPlayed.toc"
  "GlobalPlayed/README.md"
  "GlobalPlayed/CHANGELOG.md"
)

MISSING=false

for file in "${FILES_TO_CHECK[@]}"; do
  if ! grep -q "$VERSION" "$file"; then
    echo "❌ Version not found in $file"
    MISSING=true
  else
    echo "✅ Version found in $file"
  fi
done

if [ "$MISSING" = true ]; then
  echo "❌ Version mismatch detected! Please update all version references."
  exit 1  # Stop the CI with an error
else
  echo "✅ All version references are correct."
fi
