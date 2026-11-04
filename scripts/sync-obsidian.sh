#!/usr/bin/env bash
# Run manually with -batch false to review and resolve conflicts interactively.
set -euo pipefail

export UNISON="${XDG_STATE_HOME:-$HOME/.local/state}/pedromadruga-content-sync"
exec "$HOME/.local/bin/unison-blog-sync" blog-content "$@"
