#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${HF_TOKEN:-}" ]]; then
    hf auth login --token "$HF_TOKEN" --add-to-git-credential
fi

if [[ -f /work/train.sh ]]; then
    source /work/.venv/bin/activate
    exec bash /work/train.sh
fi

exec bash
