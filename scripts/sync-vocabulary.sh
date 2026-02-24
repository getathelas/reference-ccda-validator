#!/usr/bin/env bash
set -euo pipefail

# Sync vocabulary data from GCS into validator/vocabulary.
# Requires: gcloud CLI installed and authenticated with access to the bucket.
#
# Usage:
#   ./scripts/sync-vocabulary.sh
#
# First-time auth (if needed):
#   gcloud auth login

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VOCAB_DIR="$REPO_ROOT/validator/vocabulary"
GCS_VOCAB="gs://health-bridge-st-ccda-validator-vocabulary/vocabulary"

echo "Ensuring gcloud is authenticated..."
if ! gcloud auth print-access-token &>/dev/null; then
  echo "Run: gcloud auth login"
  exit 1
fi

echo "Creating local directory: $VOCAB_DIR"
mkdir -p "$VOCAB_DIR"

echo "Syncing from $GCS_VOCAB to $VOCAB_DIR ..."
gsutil -m rsync -r "$GCS_VOCAB" "$VOCAB_DIR"

echo "Done. Vocabulary is in validator/vocabulary (ignored by .gitignore)."
