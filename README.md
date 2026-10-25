[![Netlify Status](https://api.netlify.com/api/v1/badges/890c3122-d11b-44fa-a95a-be8de5632911/deploy-status)](https://app.netlify.com/sites/silly-noyce-919da2/deploys)

## Setup

```bash
bash scripts/setup.sh
```

## Development

```bash
hugo serve -D
```

## Update PaperMod

```bash
bun run theme:update   # backup, fast-forward the submodule, test build, list forked templates to re-diff
bun run theme:rollback # restore the previous theme commit from a backup
```

Use the script rather than a bare `git submodule update --remote --merge`: it keeps a backup, runs a build test, and reminds you to re-diff the forked theme templates in `layouts/`. Details in `docs/THEME_UPDATE.md`.

If the theme directory is empty after a fresh clone:

```bash
git submodule update --init --recursive
```
