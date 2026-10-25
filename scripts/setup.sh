#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION="0.168.0"
HTMLTEST_VERSION="0.17.0"
BUN_VERSION="1.4.3"
INSTALL_DIR="${HOME}/.local/bin"

# Colors
red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
dim() { printf '\033[0;2m%s\033[0m\n' "$*"; }

info() { printf '  %s %s\n' "$1" "$2"; }

check_cmd() { command -v "$1" &>/dev/null; }

# verify_sha256 <checksums-file> <archive>: run in the directory holding both.
# macOS has no sha256sum (it ships shasum), Linux usually lacks shasum.
verify_sha256() {
  local sums=$1 archive=$2
  if check_cmd sha256sum; then
    grep " ${archive}\$" "$sums" | sha256sum -c -
  else
    grep " ${archive}\$" "$sums" | shasum -a 256 -c -
  fi
}

# download_verified <release-base-url> <file> <checksums-file> <dest-dir>
# Downloads <file> and its checksums file into <dest-dir> and verifies the
# SHA256 of <file>. Aborts the script on a failed download or a mismatch.
download_verified() {
  local base=$1 file=$2 sums=$3 dest=$4
  if ! curl -fsSL -o "$dest/$file" "$base/$file" \
     || ! curl -fsSL -o "$dest/$sums" "$base/$sums"; then
    rm -rf "$dest"
    red "Download failed: $base/$file"
    exit 1
  fi
  if ! ( cd "$dest" && verify_sha256 "$sums" "$file" ) &>/dev/null; then
    rm -rf "$dest"
    red "Checksum verification failed for $file"
    exit 1
  fi
}

# fetch_verified <release-base-url> <archive> <checksums-file> <dest-dir> <member>
# Downloads and verifies a .tar.gz, then extracts a single member into <dest-dir>.
fetch_verified() {
  local base=$1 archive=$2 sums=$3 dest=$4 member=$5
  local tmp
  tmp=$(mktemp -d)
  download_verified "$base" "$archive" "$sums" "$tmp"
  tar xzf "$tmp/$archive" -C "$dest" "$member"
  rm -rf "$tmp"
}

detect_arch() {
  local arch
  arch=$(uname -m)
  case "$arch" in
    x86_64)  echo "amd64" ;;
    aarch64) echo "arm64" ;;
    arm64)   echo "arm64" ;;
    *)       red "Unsupported architecture: $arch"; exit 1 ;;
  esac
}

detect_os() {
  local os
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "$os" in
    linux)  echo "linux" ;;
    darwin) echo "darwin" ;;
    *)      red "Unsupported OS: $os"; exit 1 ;;
  esac
}

install_hugo() {
  if check_cmd hugo; then
    local current
    # sed, not grep -P: macOS grep has no PCRE
    current=$(hugo version | sed -E 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
    if [ "$current" = "$HUGO_VERSION" ]; then
      info "$(green '✓')" "Hugo $HUGO_VERSION already installed"
      return
    fi
    dim "  Found Hugo $current, pinning $HUGO_VERSION in $INSTALL_DIR"
  fi

  local os arch base sums
  os=$(detect_os)
  arch=$(detect_arch)
  base="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}"
  sums="hugo_${HUGO_VERSION}_checksums.txt"

  mkdir -p "$INSTALL_DIR"
  printf '  Installing Hugo %s (%s/%s)... ' "$HUGO_VERSION" "$os" "$arch"
  if [ "$os" = "darwin" ]; then
    # Hugo ships macOS only as a universal .pkg installer, no tar.gz. Pull the
    # binary out of the package instead of running the installer, so the pin
    # lives in $INSTALL_DIR like everything else.
    local pkg tmp
    pkg="hugo_extended_${HUGO_VERSION}_darwin-universal.pkg"
    tmp=$(mktemp -d)
    download_verified "$base" "$pkg" "$sums" "$tmp"
    pkgutil --expand-full "$tmp/$pkg" "$tmp/expanded"
    install -m 755 "$tmp/expanded/Payload/hugo" "$INSTALL_DIR/hugo"
    rm -rf "$tmp"
  else
    fetch_verified "$base" \
      "hugo_extended_${HUGO_VERSION}_${os}-${arch}.tar.gz" \
      "$sums" "$INSTALL_DIR" hugo
  fi
  green "done"
}

install_htmltest() {
  if check_cmd htmltest; then
    local current
    current=$(htmltest --version 2>/dev/null | sed -E 's/.*v?([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
    if [ "$current" = "$HTMLTEST_VERSION" ]; then
      info "$(green '✓')" "htmltest $HTMLTEST_VERSION already installed"
      return
    fi
    dim "  Found htmltest $current, pinning $HTMLTEST_VERSION in $INSTALL_DIR"
  fi

  local os arch
  os=$(detect_os)
  arch=$(detect_arch)
  # htmltest names its assets linux_amd64, macos_arm64, ... ("macos", not "darwin")
  [ "$os" = "darwin" ] && os="macos"

  mkdir -p "$INSTALL_DIR"
  printf '  Installing htmltest %s... ' "$HTMLTEST_VERSION"
  fetch_verified \
    "https://github.com/wjdp/htmltest/releases/download/v${HTMLTEST_VERSION}" \
    "htmltest_${HTMLTEST_VERSION}_${os}_${arch}.tar.gz" \
    "htmltest_${HTMLTEST_VERSION}_checksums.txt" \
    "$INSTALL_DIR" htmltest
  green "done"
}

# The official installer creates bunx as a symlink to bun (bun checks its
# argv[0]); installing the bare binary skips that, so make sure it exists.
ensure_bunx() {
  if ! check_cmd bunx; then
    mkdir -p "$HOME/.bun/bin"
    ln -sf "$(command -v bun)" "$HOME/.bun/bin/bunx"
  fi
}

install_bun() {
  if check_cmd bun; then
    local current
    current=$(bun --version)
    if [ "$current" = "$BUN_VERSION" ]; then
      info "$(green '✓')" "Bun $BUN_VERSION already installed"
      ensure_bunx
      return
    fi
    dim "  Found Bun $current, pinning $BUN_VERSION in $HOME/.bun/bin"
  fi

  if ! check_cmd unzip; then
    red "unzip is required to install Bun"
    exit 1
  fi

  local os arch bun_arch
  os=$(detect_os)
  arch=$(detect_arch)
  case "$arch" in
    amd64) bun_arch="x64" ;;
    arm64) bun_arch="aarch64" ;;
  esac

  printf '  Installing Bun %s... ' "$BUN_VERSION"
  local tmp archive base
  tmp=$(mktemp -d)
  archive="bun-${os}-${bun_arch}.zip"
  base="https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}"
  download_verified "$base" "$archive" SHASUMS256.txt "$tmp"
  unzip -qo "$tmp/$archive" -d "$tmp"
  mkdir -p "$HOME/.bun/bin"
  install -m 755 "$tmp/bun-${os}-${bun_arch}/bun" "$HOME/.bun/bin/bun"
  ln -sf bun "$HOME/.bun/bin/bunx"
  rm -rf "$tmp"
  export PATH="$HOME/.bun/bin:$PATH"
  green "done"
}

# The script puts ~/.local/bin and ~/.bun/bin on its own PATH; tell the user
# how to do the same persistently, in their shell's syntax (fish has no
# .profile-style export — fish_add_path stores the entry permanently).
path_hint() {
  local missing=() d
  for d in "$INSTALL_DIR" "$HOME/.bun/bin"; do
    [[ ":$ORIG_PATH:" == *":$d:"* ]] || missing+=("$d")
  done
  [ ${#missing[@]} -eq 0 ] && return
  echo ""
  echo "Add to your PATH (once, then open a new terminal):"
  case "$(basename "${SHELL:-bash}")" in
    fish)
      dim "  fish_add_path ${missing[*]//$HOME/~}"
      ;;
    zsh)
      dim "  echo 'export PATH=\"$(IFS=:; echo "${missing[*]//$HOME/\$HOME}"):\$PATH\"' >> ~/.zshrc"
      ;;
    *)
      dim "  echo 'export PATH=\"$(IFS=:; echo "${missing[*]//$HOME/\$HOME}"):\$PATH\"' >> ~/.bashrc"
      ;;
  esac
}

main() {
  echo ""
  echo "Setting up pedromadruga.com development environment"
  echo ""
  ORIG_PATH="$PATH"

  # Ensure ~/.local/bin is on PATH
  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    export PATH="$INSTALL_DIR:$PATH"
  fi

  # Bun
  if [[ ":$PATH:" != *":.bun/bin:"* ]] && [ -d "$HOME/.bun/bin" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
  fi

  echo "Dependencies:"
  install_bun
  install_hugo
  install_htmltest

  echo ""
  echo "Project setup:"

  # Git submodules (theme)
  if [ ! -f "themes/PaperMod/theme.toml" ] && [ ! -f "themes/PaperMod/hugo.toml" ]; then
    printf '  Initializing theme submodule... '
    git submodule update --init --recursive &>/dev/null
    green "done"
  else
    info "$(green '✓')" "Theme submodule initialized"
  fi

  # Node dependencies
  printf '  Installing npm packages... '
  bun install --frozen-lockfile &>/dev/null
  green "done"

  path_hint

  echo ""
  green "Ready! Run 'hugo serve -D' to start the dev server."
  echo ""
}

# Run from repo root
cd "$(dirname "$0")/.."
main
