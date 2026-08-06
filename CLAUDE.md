# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hugo static site (theme: PaperMod via git submodule) for pedromadruga.com. Deployed to Netlify. Hugo version: 0.147.8.

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

- **Content** (`content/`): Markdown files with Hugo front matter. Blog posts in `content/blog/`. Static pages: about, cv, newsletter, contact, search.
- **Layouts** (`layouts/`): Custom templates that override/extend the PaperMod theme. Key customizations:
  - `layouts/_default/_markup/render-image.html` — image render hook for automatic AVIF/WebP responsive images
  - `layouts/partials/extend_head.html` — font preloading and SEO structured data (JSON-LD)
  - `layouts/partials/footer.html` — JavaScript loading via Hugo Pipes (bundled, minified, fingerprinted)
  - `layouts/partials/seo/` — schema.org structured data partials
  - `layouts/shortcodes/responsive-img.html` — manual responsive image shortcode
- **Assets** (`assets/`): CSS overrides in `assets/css/extended/`. Modular JS files in `assets/js/` (theme toggle, code copy, smooth scroll, scroll-to-top, menu scroll).
- **Static** (`static/`): Images, favicon, CV PDF. Blog post images in `static/posts/`.
- **Theme** (`themes/PaperMod/`): Git submodule. Do not edit directly — override via `layouts/`.
- **Config** (`hugo.yaml`): Site configuration, menus, params, image processing settings.

## CI Pipeline

GitHub Actions workflow (`.github/workflows/lint.yml`) runs two parallel jobs:

- **lint** — installs Bun dependencies, runs markdown linting and Prettier formatting checks. Does not need the theme submodule.
- **build** — checks out with submodules, builds Hugo site with `--minify`, then runs `htmltest` for HTML validation. Caches Hugo resources and the htmltest binary.

Both jobs run on every push to `master` and on pull requests targeting `master`.

## Key Conventions

- Theme customizations go in `layouts/`, never edit `themes/PaperMod/` directly.
- Blog posts use front matter type `"blog"` and live in `content/blog/`.
- Images are automatically optimized (AVIF/WebP, srcset, lazy loading) through the render-image hook.
- JavaScript is bundled via `resources.Concat` in `layouts/partials/footer.html` into a single `main.js` (menu-scroll, smooth-scroll, scroll-to-top, theme-toggle). `code-copy.js` loads separately on post pages only. Add new JS files to `assets/js/` and reference them in `footer.html`.
- Markdown linting rules are in `.markdownlint.json`. Line length (MD013) is disabled. Several HTML elements are allowed via MD033.
- Deployment is automatic via Netlify on push to master. Preview deploys are created for PRs.

## Git Hooks

Pre-commit hooks are managed by [Lefthook](https://github.com/evilmartians/lefthook) (`lefthook.yml`). Hooks run in parallel on staged files:

- **lint-markdown** — runs `markdownlint-cli2` on staged `.md` files
- **check-formatting** — runs `prettier --check` on staged `.json`, `.yaml`, `.yml` files

Hooks install automatically via the `prepare` script (`bun install` / `npm install`). To skip hooks for a commit: `git commit --no-verify`. Local overrides go in `lefthook-local.yml` (gitignored).

## Troubleshooting

- If search returns repeated results in dev mode, restart the Hugo server.
- Theme submodule not cloned: `git submodule update --init --recursive`
