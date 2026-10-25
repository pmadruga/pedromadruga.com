# Netlify build hook for the daily /notes/ refresh

`.github/workflows/daily-deploy.yml` refreshes the /notes/ Bluesky feed once a day by asking Netlify to rebuild the site. It does that through a **build hook**: a secret URL that can do exactly one thing, start a build of this site. It replaced a personal access token (which could do anything on the whole Netlify account) and a pinned `netlify-cli` dependency tree.

The migration needs a one-time setup in Netlify and GitHub. Until step 2 is done, the scheduled run fails with `NETLIFY_BUILD_HOOK_URL secret is not set` — nothing else is affected, pushes still deploy as usual.

## 1. Create the build hook in Netlify

1. Open the site in Netlify → **Site configuration** → **Build & deploy** → **Continuous deployment**.
2. Scroll to **Build hooks** → **Add build hook**.
3. Name: `Daily notes feed refresh` (free text; it only labels the deploy). Branch to build: `master`.
4. **Save**, then copy the URL. It looks like `https://api.netlify.com/build_hooks/<id>`. Treat it as a secret: anyone with it can start builds (not deploy arbitrary content, but still).

## 2. Store the URL as a GitHub Actions secret

From the repo directory, with the GitHub CLI:

```bash
gh secret set NETLIFY_BUILD_HOOK_URL
# paste the URL at the prompt, then Enter
```

Or in the browser: repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**, name `NETLIFY_BUILD_HOOK_URL`.

## 3. Test it

```bash
gh workflow run daily-deploy.yml
gh run watch
```

The workflow only confirms that the hook was called (an HTTP 200 from Netlify). The build itself happens on Netlify:

1. Netlify → **Deploys**: a new deploy appears, labelled "Deploy triggered by hook: Daily notes feed refresh".
2. Open its log. Near the top of the build step it must print `Build started by hook 'Daily notes feed refresh': requiring a non-empty Bluesky feed` — that line comes from `scripts/netlify-build.sh` and proves the hook path (not the push path) ran.
3. When it finishes, `/notes/` on the live site shows the latest posts.

## 4. Retire the old credentials

Only after step 3 works:

1. Netlify → **User settings** → **Applications** → **Personal access tokens** → revoke the token that was used for the daily deploy.
2. Delete the GitHub secrets it needed:

   ```bash
   gh secret delete NETLIFY_AUTH_TOKEN
   gh secret delete NETLIFY_SITE_ID
   ```

## 5. Get told when a hook build fails (recommended)

A hook-triggered build fails on purpose when the Bluesky API returns an empty feed, so yesterday's /notes/ stays live instead of an empty page. The GitHub workflow cannot see that failure, so turn on Netlify's notification: **Site configuration** → **Notifications** → **Emails and webhooks** → **Add notification** → **Deploy failed** → your email.

## How the two build paths differ

`netlify.toml` runs `bash scripts/netlify-build.sh` for production builds:

| Trigger          | `INCOMING_HOOK_TITLE` | Empty Bluesky feed                                   |
| ---------------- | --------------------- | ---------------------------------------------------- |
| Push to `master` | unset                 | builds anyway, /notes/ is empty until the next build |
| Daily build hook | set by Netlify        | build fails, previous deploy stays live              |

A push stays lenient so a code fix can ship during a Bluesky outage.

## Troubleshooting

- **Workflow fails with `NETLIFY_BUILD_HOOK_URL secret is not set`** — step 2 was skipped, or the secret was deleted.
- **`curl: (22) ... 404`** — the hook was deleted in Netlify. Create a new one (step 1) and update the secret (step 2); the old URL cannot be revived.
- **Netlify deploy failed with `Bluesky feed is empty and HUGO_NOTES_REQUIRE_FEED is set`** — expected during a Bluesky outage; the previous deploy is still live and tomorrow's run will retry. If it keeps failing, check `https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=pedromadruga.com` in a browser.
- **Rotating the hook** — delete it in Netlify, create a new one, update the secret. Nothing in the repo changes.
