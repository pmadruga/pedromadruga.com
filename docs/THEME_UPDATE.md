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
npm run theme:update
```

This command:
1. Creates a backup of the current theme
2. Updates to the latest PaperMod version
3. Tests the Hugo build
4. Rolls back automatically if build fails

### Update Without Testing

```bash
npm run theme:update-safe
```

Updates the theme without running build tests (faster, but less safe).

## Available Commands

### NPM Scripts

```bash
# Update theme with build test
npm run theme:update

# Update theme without build test
npm run theme:update-safe

# Rollback to a previous backup
npm run theme:rollback

# List all available backups
npm run theme:list-backups
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
   - Runs `hugo --minify`
   - Checks for build errors
   - Auto-rollback if build fails

5. **Cleanup**
   - Keeps last 5 backups
   - Removes older backups automatically

### Backup Structure

```
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
npm run theme:rollback
```

You'll see a list of available backups:

```
Available backups:
  - PaperMod_20251030_143022 (commit: a1b2c3d4)
  - PaperMod_20251029_091545 (commit: e5f6g7h8)
  - PaperMod_20251028_164432 (commit: i9j0k1l2)

Enter backup name to restore (or 'latest' for most recent):
```

Type `latest` for the most recent backup, or paste a specific backup name.

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
3. Run rollback to restore: `npm run theme:rollback`

### Build Fails After Update

**Problem:** Hugo build fails with the new theme version

**Solution:**
1. If you used `--test`, rollback happens automatically
2. If not, manually rollback: `npm run theme:rollback`
3. Report the issue to PaperMod: https://github.com/adityatelange/hugo-PaperMod/issues

### Theme Not Found

**Problem:** Script says "Theme not found"

**Solution:**
The script will automatically initialize the theme submodule:

```bash
bash scripts/update-theme.sh
```

Or manually:

```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
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

2. **Check customizations**
   - Review your custom layouts in `layouts/`
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

If you prefer manual updates without the script:

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

Your customizations override theme defaults and won't be affected by updates.

## Script Options Reference

```
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
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'

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
