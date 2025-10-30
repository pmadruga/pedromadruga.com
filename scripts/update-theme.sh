#!/bin/bash
# PaperMod Theme Update Script
# Automatically updates the PaperMod theme with backup and rollback capability

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
THEME_PATH="themes/PaperMod"
BACKUP_DIR=".theme-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="${BACKUP_DIR}/PaperMod_${TIMESTAMP}"

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to check if running in git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not a git repository. Please run this from the project root."
        exit 1
    fi
}

# Function to check if theme submodule exists
check_submodule() {
    if [ ! -d "$THEME_PATH" ]; then
        print_error "Theme not found at $THEME_PATH"
        print_info "Initializing theme submodule..."
        git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
        git submodule update --init --recursive
        print_success "Theme submodule initialized"
        exit 0
    fi
}

# Function to get current theme commit
get_current_commit() {
    cd "$THEME_PATH"
    git rev-parse HEAD
    cd - > /dev/null
}

# Function to get current theme version/tag
get_current_version() {
    cd "$THEME_PATH"
    git describe --tags --abbrev=0 2>/dev/null || echo "no-tag"
    cd - > /dev/null
}

# Function to create backup
create_backup() {
    print_info "Creating backup of current theme..."

    mkdir -p "$BACKUP_DIR"

    # Copy theme directory
    cp -r "$THEME_PATH" "$BACKUP_PATH"

    # Save current commit hash
    get_current_commit > "${BACKUP_PATH}/.commit-hash"

    print_success "Backup created at $BACKUP_PATH"
}

# Function to restore from backup
restore_backup() {
    if [ -z "$1" ]; then
        print_error "No backup path specified"
        return 1
    fi

    local backup_path="$1"

    if [ ! -d "$backup_path" ]; then
        print_error "Backup not found at $backup_path"
        return 1
    fi

    print_warning "Restoring from backup..."
    rm -rf "$THEME_PATH"
    cp -r "$backup_path" "$THEME_PATH"
    print_success "Theme restored from backup"
}

# Function to update theme
update_theme() {
    print_info "Fetching latest theme updates..."

    cd "$THEME_PATH"

    # Fetch latest changes
    git fetch origin master

    # Get latest commit info
    local latest_commit=$(git rev-parse origin/master)
    local current_commit=$(git rev-parse HEAD)

    if [ "$latest_commit" = "$current_commit" ]; then
        print_success "Theme is already up to date!"
        cd - > /dev/null
        return 0
    fi

    # Show what will be updated
    print_info "Changes to be applied:"
    git log --oneline HEAD..origin/master | head -10

    # Update to latest
    print_info "Updating theme to latest version..."
    git merge --ff-only origin/master || {
        print_error "Failed to update theme (merge conflict)"
        cd - > /dev/null
        return 1
    }

    cd - > /dev/null
    print_success "Theme updated successfully!"
}

# Function to test build
test_build() {
    print_info "Testing Hugo build..."

    if command -v hugo >/dev/null 2>&1; then
        if hugo --minify --quiet 2>&1 | grep -i "error"; then
            print_error "Build test failed!"
            return 1
        else
            print_success "Build test passed!"
            return 0
        fi
    else
        print_warning "Hugo not found, skipping build test"
        return 0
    fi
}

# Function to show available backups
list_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        print_info "No backups found"
        return
    fi

    print_info "Available backups:"
    ls -1t "$BACKUP_DIR" | while read backup; do
        local backup_path="${BACKUP_DIR}/${backup}"
        local commit_hash=""
        if [ -f "${backup_path}/.commit-hash" ]; then
            commit_hash=$(cat "${backup_path}/.commit-hash")
        fi
        echo "  - $backup (commit: ${commit_hash:0:8})"
    done
}

# Function to clean old backups (keep last 5)
clean_old_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        return
    fi

    local backup_count=$(ls -1 "$BACKUP_DIR" | wc -l)

    if [ "$backup_count" -gt 5 ]; then
        print_info "Cleaning old backups (keeping last 5)..."
        ls -1t "$BACKUP_DIR" | tail -n +6 | while read backup; do
            rm -rf "${BACKUP_DIR}/${backup}"
            print_info "Removed old backup: $backup"
        done
    fi
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Automatically update the PaperMod Hugo theme with backup and rollback capability.

OPTIONS:
    -h, --help          Show this help message
    -u, --update        Update theme to latest version (default)
    -l, --list-backups  List available backups
    -r, --rollback      Rollback to previous backup
    -t, --test          Test build after update
    --no-backup         Skip backup creation (not recommended)
    --force             Force update even if up to date

EXAMPLES:
    $0                  # Update theme with backup
    $0 --update --test  # Update and test build
    $0 --list-backups   # Show available backups
    $0 --rollback       # Restore from latest backup

NOTES:
    - Backups are stored in .theme-backups/
    - Only the last 5 backups are kept
    - Add .theme-backups/ to .gitignore

EOF
}

# Main script
main() {
    local do_update=true
    local do_backup=true
    local do_test=false
    local do_rollback=false
    local do_list=false
    local force_update=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -u|--update)
                do_update=true
                shift
                ;;
            -l|--list-backups)
                do_list=true
                do_update=false
                shift
                ;;
            -r|--rollback)
                do_rollback=true
                do_update=false
                shift
                ;;
            -t|--test)
                do_test=true
                shift
                ;;
            --no-backup)
                do_backup=false
                shift
                ;;
            --force)
                force_update=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Show header
    echo ""
    print_info "PaperMod Theme Update Script"
    echo ""

    # Check prerequisites
    check_git_repo
    check_submodule

    # List backups
    if [ "$do_list" = true ]; then
        list_backups
        exit 0
    fi

    # Rollback
    if [ "$do_rollback" = true ]; then
        list_backups
        echo ""
        read -p "Enter backup name to restore (or 'latest' for most recent): " backup_name

        if [ "$backup_name" = "latest" ]; then
            backup_name=$(ls -1t "$BACKUP_DIR" | head -1)
        fi

        if [ -n "$backup_name" ]; then
            restore_backup "${BACKUP_DIR}/${backup_name}"

            if [ "$do_test" = true ]; then
                test_build
            fi
        else
            print_error "No backup selected"
            exit 1
        fi

        exit 0
    fi

    # Show current version
    print_info "Current theme version: $(get_current_version)"
    print_info "Current commit: $(get_current_commit | cut -c1-8)"
    echo ""

    # Update theme
    if [ "$do_update" = true ]; then
        # Create backup
        if [ "$do_backup" = true ]; then
            create_backup
        fi

        # Update
        if update_theme; then
            print_info "New theme version: $(get_current_version)"
            print_info "New commit: $(get_current_commit | cut -c1-8)"

            # Test build
            if [ "$do_test" = true ]; then
                if ! test_build; then
                    print_error "Build failed after update!"

                    if [ "$do_backup" = true ]; then
                        print_warning "Rolling back to previous version..."
                        restore_backup "$BACKUP_PATH"

                        if test_build; then
                            print_success "Rollback successful, build working again"
                        fi
                    fi

                    exit 1
                fi
            fi

            # Clean old backups
            clean_old_backups

            echo ""
            print_success "Theme update completed successfully!"

            if [ "$do_backup" = true ]; then
                print_info "Backup saved at: $BACKUP_PATH"
            fi

            print_info "Run 'hugo serve' to test your site with the updated theme"
        else
            print_error "Theme update failed!"

            if [ "$do_backup" = true ]; then
                print_info "Your previous theme version is backed up at: $BACKUP_PATH"
                print_info "Run '$0 --rollback' to restore if needed"
            fi

            exit 1
        fi
    fi

    echo ""
}

# Run main function
main "$@"
