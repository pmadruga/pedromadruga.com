#!/usr/bin/env bash
# Usage: bash scripts/setup-obsidian-sync.sh /path/to/unison [vault-path]
# Installs a local two-way sync and a user timer. No sudo is needed.
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
binary=${1:?Pass the path to a Unison executable}
vault=${2:-$HOME/Sync/Obsidian}
destination="$vault/8. Blogging/pedromadruga.com/content"
state="${XDG_STATE_HOME:-$HOME/.local/state}/pedromadruga-content-sync"
units="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

test -d "$vault/.obsidian"
test -d "$repo/content"
"$binary" -version
# Refuse to overwrite an existing configuration. Reruns need deliberate review.
for path in "$state/blog-content.prf" "$units/blog-content-sync.service" "$units/blog-content-sync.timer"; do
    if [[ -e "$path" ]]; then
        printf 'Already configured: %s\n' "$path" >&2
        exit 1
    fi
done
if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'Destination already exists; review before setting up: %s\n' "$destination" >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin" "$state/backups" "$units" "$destination"
install -m 755 "$binary" "$HOME/.local/bin/unison-blog-sync"

cat > "$state/blog-content.prf" <<EOF
root = $repo/content
root = $destination
batch = true
terse = true
perms = 0
backup = Name *
backuploc = central
backupdir = $state/backups
maxbackups = 10
confirmbigdel = true
log = false
ignore = Name .obsidian
ignore = Name .trash
ignore = Name .DS_Store
ignore = Name .stfolder
ignore = Name .stversions
ignore = Name *.sync-conflict-*
EOF

cat > "$units/blog-content-sync.service" <<EOF
[Unit]
Description=Sync Hugo content with the Obsidian blogging folder

[Service]
Type=oneshot
Environment="UNISON=$state"
ExecStartPre=/usr/bin/test -d "$repo/content"
ExecStartPre=/usr/bin/test -d "$destination"
ExecStart="$HOME/.local/bin/unison-blog-sync" blog-content -ui text
# Unison exits 1 when conflicts are skipped. Leave both versions for review.
SuccessExitStatus=1
UMask=0077
EOF

cat > "$units/blog-content-sync.timer" <<EOF
[Unit]
Description=Check for blog edits every 10 seconds

[Timer]
OnStartupSec=15s
OnUnitInactiveSec=10s
AccuracySec=1s

[Install]
WantedBy=timers.target
EOF

# Seed and record both replicas before enabling periodic synchronization.
bash "$repo/scripts/sync-obsidian.sh" -ui text
systemctl --user daemon-reload
systemctl --user enable --now blog-content-sync.timer
systemctl --user start blog-content-sync.service
printf 'Two-way sync enabled: %s <-> %s\n' "$repo/content" "$destination"
printf 'Backups: %s/backups\n' "$state"
printf 'Resolve conflicts: bash "%s/scripts/sync-obsidian.sh" -batch false\n' "$repo"
