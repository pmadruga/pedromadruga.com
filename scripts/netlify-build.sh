#!/usr/bin/env bash
# Netlify production build command (netlify.toml [build]).
#
# The daily refresh (.github/workflows/daily-deploy.yml) is a Netlify build
# hook, and a hook-triggered build must not publish an empty /notes/ page
# when the Bluesky API is down: with HUGO_NOTES_REQUIRE_FEED set,
# layouts/notes.html fails the build on an empty feed, and a failed Netlify
# build leaves the previous deploy live. Push-triggered builds keep the
# lenient behaviour (an empty feed renders an empty page) so a code fix can
# still ship during an API outage. Netlify sets INCOMING_HOOK_* only on
# builds started by a hook.
set -euo pipefail

if [ -n "${INCOMING_HOOK_TITLE:-}" ]; then
  echo "Build started by hook '${INCOMING_HOOK_TITLE}': requiring a non-empty Bluesky feed"
  export HUGO_NOTES_REQUIRE_FEED=true
fi

hugo --gc --minify
