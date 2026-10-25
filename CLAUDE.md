# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository. `AGENTS.md` (read by Codex) is a symlink to it — edit this file only.

## Project Overview

Hugo static site (theme: PaperMod via git submodule) for pedromadruga.com. Deployed to Netlify. Hugo version: 0.168.0.

## Getting Started

```bash
bash scripts/setup.sh      # Install Hugo, htmltest, Bun, deps, theme submodule
hugo serve -D              # Start dev server at localhost:1313
```

## Commands

### Development

```bash
hugo serve -D              # Local dev server with drafts at localhost:1313
```

### Build

```bash
hugo                       # Build to public/
```

### Linting & Formatting

```bash
npm run lint               # Lint markdown files
npm run lint:fix           # Auto-fix markdown issues
npm run format             # Format JSON/YAML with Prettier
npm run format:check       # Check formatting without changes
```

### Theme Management

```bash
npm run theme:update       # Update PaperMod theme (with build test)
npm run theme:rollback     # Rollback to previous theme version
```

## Architecture

- **Content** (`content/`): Markdown files with Hugo front matter. Blog posts in `content/blog/`. Static pages: about, cv (draft, menu-disabled), newsletter (in the nav menu; carries the same post archive as /blog/ via the shared `post_archive.html` partial), newsletter-thanks/-confirmed (Buttondown redirect targets, noindexed), booking-confirmed (meetergo redirect target at `/booking/confirmed/`, noindexed — meetergo disables its own success page once a redirect URL is set), contact, notes (build-time Bluesky feed via `layouts/notes.html`, no client JS; refreshed by the daily deploy workflow `.github/workflows/daily-deploy.yml`, which sets `HUGO_NOTES_REQUIRE_FEED=true` so an empty feed fails the build instead of deploying an empty page).
- **Layouts** (`layouts/`): Custom templates that override/extend the PaperMod theme. Key customizations:
  - `layouts/_markup/render-image.html` — image render hook for automatic WebP responsive images
  - `layouts/_partials/extend_head.html` — font preloading and SEO structured data (JSON-LD)
  - `layouts/_partials/footer.html` — JavaScript loading via Hugo Pipes (bundled, minified, fingerprinted)
  - `layouts/_partials/seo/` — schema.org structured data partials
  - `layouts/_partials/profile-image.html` — resolves the homepage portrait to its 1x/2x WebP variants, shared by `index_profile.html` and the LCP preload in `extend_head.html`
  - `layouts/_partials/templates/_funcs/share-images.html` — the og:image/twitter:image source (front-matter `images:` first, then `cover.image`, then the site default) with real width/height/alt
- **Assets** (`assets/`): CSS overrides in `assets/css/extended/` (link/icon accent color is the `--amber` custom property defined in `custom_css1.css`). Modular JS files in `assets/js/` (theme toggle, code copy, smooth scroll, scroll-to-top, menu scroll).
- **Static** (`static/`): Favicons, CV PDF and `images/og-default.png`. Blog post images live in each post's page bundle (`content/blog/<slug>/`).
- **Theme** (`themes/PaperMod/`): Git submodule. Do not edit directly — override via `layouts/`.
- **Config** (`hugo.yaml`): Site configuration, menus, params, image processing settings.

## CI Pipeline

GitHub Actions workflows:

- **`lint.yml`** — two parallel jobs: **lint** (Bun deps, markdown linting, Prettier checks) and **build** (submodule checkout, Hugo `--minify` build, `htmltest` HTML validation, with a Hugo-resource cache). Runs on all PRs targeting `master`; on pushes to `master` only when the `paths:` filter matches. htmltest is installed by the composite action `.github/actions/setup-htmltest/` (shared with `link-check.yml`): it caches the release archive, not the binary, so the sha256 check runs on every job.
- **`daily-deploy.yml`** — scheduled (05:23 UTC) build-and-deploy to Netlify, so the /notes/ Bluesky feed refreshes daily without a push. The CLI comes from `.github/netlify-cli/` (a `package.json` + `bun.lock` pinning `netlify-cli`, installed with `--frozen-lockfile --ignore-scripts`; Dependabot tracks it) — never switch back to a bare `npx netlify-cli`, the account-wide token is in env during that step. Needs `NETLIFY_AUTH_TOKEN`/`NETLIFY_SITE_ID` repo secrets. Fails (deliberately) if the Bluesky feed comes back empty.
- **`link-check.yml`** — weekly external-link check via htmltest.

Version pins that must move in lockstep: Hugo in `netlify.toml`, `lint.yml`, `link-check.yml`, `daily-deploy.yml`, `scripts/setup.sh`; Bun in `netlify.toml`, `lint.yml`, `daily-deploy.yml`, `scripts/setup.sh`; Node in `.nvmrc` + `netlify.toml`; htmltest in the `HTMLTEST_VERSION` env of `lint.yml` and `link-check.yml`, the input default in `.github/actions/setup-htmltest/action.yml`, and `scripts/setup.sh`.

## Key Conventions

- **Never co-author commits.** Do not add `Co-Authored-By`, session links, or any other AI attribution trailers to commit messages.
- **Always commit draft posts too.** When asked to commit, also commit any modified draft under `content/blog/` in its own separate commit (never mixed with code or layout changes) and push it along with the rest. Drafts are Pedro's writing, so commit them as they are without editing the text.
- Theme customizations go in `layouts/`, never edit `themes/PaperMod/` directly.
- Blog posts use front matter type `"blog"` and live in `content/blog/`.
- Images are automatically optimized (WebP, srcset up to 1200w for the 720px column, lazy loading) through the render-image hook. Every in-content image is lazy; a post whose first image is above the fold opts in with `eagerFirstImage: true` in front matter. WebP quality is set once in `hugo.yaml` (`imaging.webp.quality`) — the render hook, `cover.html` and `profile-image.html` deliberately omit a `q` in their resize specs. AVIF was removed deliberately: Hugo's encoder produced files 40–65% *larger* than the WebP equivalents on this site's screenshot-heavy images.
- **`lastmod` is explicit, not git-derived.** `frontmatter.lastmod` in `hugo.yaml` drops Hugo's default `:git` source, which marked every old post "modified" on housekeeping commits (sitemap `lastmod`, `article:modified_time`, JSON-LD `dateModified`). A substantively revised post gets a `lastmod:` in its front matter; otherwise it equals `date`.
- JavaScript is bundled via `resources.Concat` in `layouts/_partials/footer.html` into a single `main.js` (menu-scroll, smooth-scroll, scroll-to-top, theme-toggle). `code-copy.js` loads separately, only on blog posts that contain a `<pre>` — that decision is the `$codeCopy` cache key in `baseof.html` (the footer is `partialCached`, so any per-page condition must be in the key). Add new JS files to `assets/js/` and reference them in `footer.html`.
- Markdown linting rules are in `.markdownlint-cli2.yaml` (under the `config:` key). Line length (MD013) is disabled. Several HTML elements are allowed via MD033.
- Deployment is automatic via Netlify on push to master. Preview deploys are created for PRs.
- **No inline styles.** The CSP's `style-src` is `'self'` only, so `<style>` blocks and `style=` attributes are silently ignored by browsers. Put CSS in `assets/css/extended/` (or a linked file). The `inline-svg` shortcode strips the root `<svg>`'s `style` attribute and fails the build on any other inline style — use SVG presentation attributes instead. It also fails the build on `<script>`, `on*=` handlers, `<foreignObject>` and `javascript:` URLs, since the file is injected with `safeHTML`.
- **Decorative images use `alt=""`** (the /notes/ avatars; the name and handle follow as text). htmltest has `IgnoreAltEmpty: true` for that; a *missing* alt still fails CI.
- **No taxonomies.** `disableKinds: [taxonomy, term]` in `hugo.yaml` — no post uses tags/categories, and the empty `/tags/` + `/categories/` pages were indexable and in the sitemap. Remove that line if tags are ever adopted.
- **Rename-on-change for post media.** Everything under `/blog/<slug>/`, `/about/` and `/images/` is served with `Cache-Control: immutable` (netlify.toml). Hugo's `_hu_`-hashed image variants handle this automatically, but source images, videos, posters, and static files like `images/og-default.png` keep their names in URLs — so never replace one in place: give the new file a new name (e.g. `-v2` suffix) and update references, or browsers/CDNs will serve the stale copy for up to a year.
- **Forked theme templates.** These are full copies of theme files, not extensions, so they permanently shadow the theme's versions and will not receive upstream fixes. After `npm run theme:update`, diff each against its `themes/PaperMod/` counterpart and port changes manually:
  - `layouts/_partials/cover.html` — adds WebP `<picture>` sources, caps srcset at 1500w
  - `layouts/_partials/head.html` — theme copy; diverges in the favicon block, the theme's inline `<noscript>` styles moved to a linked `assets/css/noscript/` bundle, a real `<meta name=author>` (the emptied `author.html` override would blank it), whitespace-collapsed meta description, `noindex` on the 404 page, and no opengraph/schema blocks on `robotsNoIndex` pages. The CSP-hashed inline theme script is untouched theme code.
  - `layouts/_partials/footer.html` — theme copy minus the inline scripts (CSP) and the "Powered by" credit; bundles JS via Hugo Pipes
  - `layouts/baseof.html` — the skip link, `id="main-content"` on `<main>`, the `blog-post` body class (scopes the post heading font in `custom_css1.css`), and the `$codeCopy` footer cache key
  - `layouts/archives.html` — theme copy plus the newsletter subscribe line in the header; drops the month grouping and post counts, so under each year every entry is one row: full date, title (`h3`, no `post_meta` partial), reading time. Row layout lives in `custom_css1.css`
  - `layouts/_partials/author.html` — deliberately emptied override
  - `layouts/_partials/social_icons.html` — theme copy plus `aria-label` on each link and `aria-hidden` on the icon SVG; the `social_icons` shortcode (used on /contact/) just calls it
  - `layouts/_partials/templates/opengraph.html` and `twitter_cards.html` — theme copies whose image block comes from `_funcs/share-images.html`, adding `og:image:width/height/alt` and `twitter:image:alt`
  - `layouts/_partials/templates/schema_json.html`: limits `BlogPosting` to blog posts, uses appropriate types for other pages, omits unknown dates, links the site author to `/about/`, gives the Person a stable `@id` (`/#person`) that the homepage block, `seo/schema-website.html` and every post's author/publisher reference, drops `articleBody` (it duplicated the whole post in the HTML) and the `logo` on a Person publisher, and skips one-item `BreadcrumbList`s.
  - `layouts/robots.txt` — replaces the theme's allow-everything file: search crawlers still fall through to a permissive `User-agent: *`, while AI search/on-demand fetchers that cite sources (Claude-SearchBot, Claude-User, OAI-SearchBot, ChatGPT-User, Perplexity*, etc.) get an explicit `Allow: /` group, as does Google-Extended (it gates both Gemini training and Gemini grounding, deliberately allowed); AI training/scraping agents (and the Applebot-Extended training opt-out) each get `Disallow: /`. Add new AI user-agents to the matching group as they appear.
  - `layouts/rss.xml` — the home feed lists `mainSections` posts only (not about/contact/the noindexed newsletter pages), and root-relative `src`/`href`/`srcset` in `content:encoded` are absolutized for feed readers and RSS-to-email.

## Content Ownership

- **Written content is Pedro's alone.** Claude must never write, rewrite, or edit the site's written content — blog post prose, page copy, titles, headlines, or any reader-facing text in `content/`. Only Pedro changes written content. Claude may make structural/technical changes (front matter mechanics, shortcodes, layout, formatting fixes) when explicitly asked.
- **Video captions.** The `video` shortcode takes an optional `captions="file.vtt"` (WebVTT in the page bundle) and emits a default English `<track>`; the VTT itself is Pedro's content.
- **`summary`, not `description`, in front matter.** A `description` field renders visibly under the page title (PaperMod's post-description block), duplicating the opening prose — never add one. Use `summary` instead: it feeds the meta/og description tags and RSS without being displayed on the page.

## Git Hooks

Hooks are managed by [Lefthook](https://github.com/evilmartians/lefthook) (`lefthook.yml`). Pre-commit hooks run in parallel on staged files, invoking the lockfile's binaries from `node_modules/.bin/` (not `bunx`, which `scripts/setup.sh`'s bare-binary Bun install used to lack):

- **lint-markdown** — runs `markdownlint-cli2` on staged `.md` files
- **check-formatting** — runs `prettier --check` on staged `.json`, `.yaml`, `.yml` files

A **pre-push** hook (`hugo-build`) runs a full Hugo build as a sanity check (skipped gracefully when hugo is not installed).

Hooks install automatically via the `prepare` script (`bun install` / `npm install`). To skip hooks for a commit: `git commit --no-verify`. Local overrides go in `lefthook-local.yml` (gitignored).

## Troubleshooting

- Theme submodule not cloned: `git submodule update --init --recursive`
