#!/bin/bash
set -e

# --- Yarn setup ---
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
sudo corepack enable
yarn config set --home enableTelemetry 0
yarn dlx @yarnpkg/sdks vscode

# --- AI Agents ---
npm install -g @anthropic-ai/claude-code
claude install
npm i -g @openai/codex

# --- Optional tools (uncomment to enable) ---
# bash .devcontainer/setup-azure.sh
# bash .devcontainer/setup-redis.sh

echo "Setup complete!"
