# PaperMod Theme Update Guide

This guide explains how to safely update the PaperMod Hugo theme using the automated update script.

## Overview

The theme update script (`scripts/update-theme.sh`) provides:

- ✅ Automatic theme updates via git submodule
- ✅ Backup creation before updates
- ✅ Build testing after updates
- ✅ Easy rollback to previous versions
- ✅ Automatic cleanup of old backups

## Quick Start

### Update Theme (Recommended)

```bash
bun run theme:update
```

(`npm run theme:update` works too; the project uses Bun, matching `scripts/setup.sh`.)

This command:

1. Creates a backup of the current theme
2. Updates to the latest PaperMod version
3. Tests the Hugo build
4. Rolls back automatically if build fails
5. Lists the forked theme templates that must be re-diffed by hand (see [Forked Templates](#forked-templates))

### Update Without Testing

```bash
bun run theme:update-safe
```

Updates the theme without running build tests (faster, but less safe).

## Available Commands

### Package Scripts (Bun)

```bash
# Update theme with build test
bun run theme:update

# Update theme without build test
bun run theme:update-safe

# Rollback to a previous backup
bun run theme:rollback

# List all available backups
bun run theme:list-backups
```

### Direct Script Usage

```bash
# Update with all safety features
bash scripts/update-theme.sh --update --test

# Show help and all options
bash scripts/update-theme.sh --help

# Update without backup (not recommended)
bash scripts/update-theme.sh --update --no-backup

# Force update even if already up to date
bash scripts/update-theme.sh --update --force

# List available backups
bash scripts/update-theme.sh --list-backups

# Rollback to previous version
bash scripts/update-theme.sh --rollback
```

## How It Works

### Update Process

1. **Check Prerequisites**
   - Verifies git repository
   - Checks theme submodule exists
   - Shows current theme version

2. **Create Backup**
   - Copies entire theme directory to `.theme-backups/`
   - Saves current commit hash
   - Timestamps backup for identification

3. **Update Theme**
   - Fetches latest changes from GitHub
   - Shows commits that will be applied
   - Merges changes with fast-forward

4. **Test Build (if enabled)**
   - Runs `hugo --minify` and uses its exit status
   - Prints Hugo's output on failure
   - Auto-rollback if build fails

5. **Cleanup**
   - Keeps last 5 backups
   - Removes older backups automatically

6. **Forked-template reminder**
   - For each forked template in `layouts/`, reports whether the theme's copy changed in this update and prints the `diff -u` command to port it

### Backup Structure

```text
.theme-backups/
├── PaperMod_20251030_143022/
│   ├── .commit-hash          # Original commit
│   └── [theme files]
├── PaperMod_20251029_091545/
└── PaperMod_20251028_164432/
```

## Rollback Procedure

If you need to restore a previous theme version:

### Interactive Rollback

```bash
bun run theme:rollback
```

You'll see a list of available backups:

```text
Available backups:
  - PaperMod_20251030_143022 (commit: a1b2c3d4)
  - PaperMod_20251029_091545 (commit: e5f6g7h8)
  - PaperMod_20251028_164432 (commit: i9j0k1l2)

Enter backup name to restore (or 'latest' for most recent):
```

Type `latest` for the most recent backup, or paste a specific backup name.

Rollback checks out the commit recorded in the backup's `.commit-hash` inside the `themes/PaperMod` submodule (it does not copy files over the directory, which would clobber the submodule's `.git` link). Afterwards `git status` shows the submodule pointer back at the old commit.

### Command Line Rollback

```bash
# Rollback to latest backup
bash scripts/update-theme.sh --rollback <<< "latest"

# Rollback to specific backup
bash scripts/update-theme.sh --rollback <<< "PaperMod_20251029_091545"
```

## Troubleshooting

### Update Fails

**Problem:** Theme update encounters merge conflicts

**Solution:**

1. The script will automatically stop and show an error
2. Your original theme is preserved in the backup
3. Run rollback to restore: `bun run theme:rollback`

### Build Fails After Update

**Problem:** Hugo build fails with the new theme version

**Solution:**

1. If you used `--test`, rollback happens automatically
2. If not, manually rollback: `bun run theme:rollback`
3. Report the issue to PaperMod: https://github.com/adityatelange/hugo-PaperMod/issues

### Theme Not Found

**Problem:** Script says "Theme not found"

**Solution:**
The script will automatically initialize the theme submodule:

```bash
bash scripts/update-theme.sh
```

Or manually (the submodule is already declared in `.gitmodules`, so do not `git submodule add` it again):

```bash
git submodule update --init --recursive
```

### No Backups When Rolling Back

**Problem:** "No backups found" when trying to rollback

**Solution:**

- Backups are only created when using the update script
- If you manually updated, there's no backup
- The theme submodule uses git, so you can still use: `cd themes/PaperMod && git log` to see history

## Best Practices

### Before Updating

1. **Commit your changes**

   ```bash
   git add .
   git commit -m "Save work before theme update"
   ```

2. **Check current version**

   ```bash
   cd themes/PaperMod
   git describe --tags
   cd ../..
   ```

3. **Review PaperMod changelog**
   - Visit: https://github.com/adityatelange/hugo-PaperMod/releases
   - Check for breaking changes

### After Updating

1. **Test locally**

   ```bash
   hugo serve -D
   ```

2. **Re-diff the forked templates**
   - The script prints which forked templates' theme copies changed; for each one run the printed `diff -u themes/PaperMod/layouts/<file> layouts/<file>` and port the upstream change by hand (see [Forked Templates](#forked-templates))
   - Review the other custom layouts in `layouts/`
   - Test all pages and features
   - Check mobile responsiveness

3. **Deploy to staging first**
   - Use Netlify deploy previews
   - Test on different devices
   - Verify everything works before production

### Regular Updates

- Check for updates monthly: `cd themes/PaperMod && git fetch`
- Review release notes for new features
- Keep backups of working versions
- Test updates in development first

## Update Frequency

**Recommended Schedule:**

- **Security fixes:** Update immediately
- **Bug fixes:** Update within a week
- **Features:** Update when needed or quarterly
- **Major versions:** Test thoroughly before updating

Check for updates:

```bash
cd themes/PaperMod
git fetch origin master
git log HEAD..origin/master --oneline
cd ../..
```

## Manual Update (Alternative)

If you prefer manual updates without the script (note: this skips the backup, the build test and the forked-template reminder, so re-diff the [forked templates](#forked-templates) yourself):

```bash
# Update submodule
git submodule update --remote --merge

# Or if that fails
cd themes/PaperMod
git pull origin master
cd ../..

# Test build
hugo --minify

# Commit if successful
git add themes/PaperMod
git commit -m "Update PaperMod theme"
```

## Customizations

If you've customized the theme, updates are still safe because:

1. **Custom layouts** are in `layouts/` (not in theme)
2. **Custom assets** are in `assets/` (not in theme)
3. **Config** is in `hugo.yaml` (not in theme)
4. **Content** is in `content/` (not in theme)

Your customizations override theme defaults and won't be affected by updates, with one important exception.

### Forked Templates

Some files under `layouts/` are full copies of theme files rather than extensions. They permanently shadow the theme's versions, so they never receive upstream fixes: after every update, diff each against its `themes/PaperMod/layouts/` counterpart and port changes manually. The update script prints this list (and whether each theme copy changed) at the end of a successful run. The authoritative list and the reason for each fork live in `CLAUDE.md` under "Forked theme templates"; keep the `FORKED_TEMPLATES` array in `scripts/update-theme.sh` in sync with it:

- `layouts/_partials/cover.html`
- `layouts/_partials/head.html`
- `layouts/_partials/footer.html`
- `layouts/baseof.html`
- `layouts/archives.html`
- `layouts/_partials/author.html`
- `layouts/_partials/templates/schema_json.html`
- `layouts/robots.txt`
- `layouts/rss.xml`

```bash
# Example: port upstream changes to one forked template
diff -u themes/PaperMod/layouts/_partials/head.html layouts/_partials/head.html
```

## Script Options Reference

```text
Usage: scripts/update-theme.sh [OPTIONS]

OPTIONS:
    -h, --help          Show help message
    -u, --update        Update theme to latest version (default)
    -l, --list-backups  List available backups
    -r, --rollback      Rollback to previous backup
    -t, --test          Test build after update
    --no-backup         Skip backup creation (not recommended)
    --force             Force update even if up to date

EXAMPLES:
    scripts/update-theme.sh                  # Update with backup
    scripts/update-theme.sh --update --test  # Update and test
    scripts/update-theme.sh --list-backups   # Show backups
    scripts/update-theme.sh --rollback       # Restore backup
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Update Theme

on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
  workflow_dispatch:      # Manual trigger

jobs:
  update-theme:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: recursive

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          # Pin to the same version as netlify.toml, lint.yml, link-check.yml
          # and scripts/setup.sh (0.168.0 at the time of
          # writing); never 'latest', or the test build would not match production.
          hugo-version: '0.168.0'
          extended: true

      - name: Update theme
        run: bash scripts/update-theme.sh --update --test

      - name: Create Pull Request
        if: success()
        uses: peter-evans/create-pull-request@v5
        with:
          title: "chore: Update PaperMod theme"
          body: "Automated theme update"
          branch: "theme-update"
```

## Additional Resources

- **PaperMod GitHub:** https://github.com/adityatelange/hugo-PaperMod
- **PaperMod Documentation:** https://adityatelange.github.io/hugo-PaperMod/
- **Hugo Documentation:** https://gohugo.io/documentation/
- **Git Submodules:** https://git-scm.com/book/en/v2/Git-Tools-Submodules

## Support

If you encounter issues:

1. Check this guide first
2. Try rollback to last working version
3. Check PaperMod issues: https://github.com/adityatelange/hugo-PaperMod/issues
4. Check Hugo version compatibility
5. Review your custom modifications

## Version History

Backups include version information:

```bash
# See commit hash in backup
cat .theme-backups/PaperMod_20251030_143022/.commit-hash

# See what changed between backups
cd themes/PaperMod
git log <old-hash>..<new-hash>
```

This allows you to track exactly what changed in each update.
