#!/usr/bin/env bash
set -euo pipefail

HUGO_VERSION="0.147.8"
HTMLTEST_VERSION="0.17.0"
BUN_VERSION="1.3.14"
INSTALL_DIR="${HOME}/.local/bin"

# Colors
red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
dim() { printf '\033[0;2m%s\033[0m\n' "$*"; }

info() { printf '  %s %s\n' "$1" "$2"; }

check_cmd() { command -v "$1" &>/dev/null; }

# fetch_verified <release-base-url> <archive> <checksums-file> <dest-dir> <member>
# Downloads a .tar.gz and its checksums file, verifies the SHA256 of the
# archive, then extracts a single member. Aborts the script on any mismatch.
fetch_verified() {
  local base=$1 archive=$2 sums=$3 dest=$4 member=$5
  local tmp
  tmp=$(mktemp -d)
  curl -fsSL -o "$tmp/$archive" "$base/$archive"
  curl -fsSL -o "$tmp/$sums" "$base/$sums"
  if ! ( cd "$tmp" && grep " ${archive}\$" "$sums" | sha256sum -c - ) &>/dev/null; then
    rm -rf "$tmp"
    red "Checksum verification failed for $archive"
    exit 1
  fi
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
    current=$(hugo version | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ "$current" = "$HUGO_VERSION" ]; then
      info "$(green '✓')" "Hugo $HUGO_VERSION already installed"
      return
    fi
    dim "  Upgrading Hugo from $current to $HUGO_VERSION"
  fi

  local os arch
  os=$(detect_os)
  arch=$(detect_arch)

  mkdir -p "$INSTALL_DIR"
  printf '  Installing Hugo %s (%s/%s)... ' "$HUGO_VERSION" "$os" "$arch"
  fetch_verified \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}" \
    "hugo_extended_${HUGO_VERSION}_${os}-${arch}.tar.gz" \
    "hugo_${HUGO_VERSION}_checksums.txt" \
    "$INSTALL_DIR" hugo
  green "done"
}

install_htmltest() {
  if check_cmd htmltest; then
    info "$(green '✓')" "htmltest already installed"
    return
  fi

  local os arch
  os=$(detect_os)
  arch=$(detect_arch)

  mkdir -p "$INSTALL_DIR"
  printf '  Installing htmltest %s... ' "$HTMLTEST_VERSION"
  # htmltest uses different naming: linux_amd64, darwin_arm64, etc.
  fetch_verified \
    "https://github.com/wjdp/htmltest/releases/download/v${HTMLTEST_VERSION}" \
    "htmltest_${HTMLTEST_VERSION}_${os}_${arch}.tar.gz" \
    "htmltest_${HTMLTEST_VERSION}_checksums.txt" \
    "$INSTALL_DIR" htmltest
  green "done"
}

install_bun() {
  if check_cmd bun; then
    info "$(green '✓')" "Bun $(bun --version) already installed"
    return
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
  curl -fsSL -o "$tmp/$archive" "$base/$archive"
  curl -fsSL -o "$tmp/SHASUMS256.txt" "$base/SHASUMS256.txt"
  if ! ( cd "$tmp" && grep " ${archive}\$" SHASUMS256.txt | sha256sum -c - ) &>/dev/null; then
    rm -rf "$tmp"
    red "Checksum verification failed for $archive"
    exit 1
  fi
  unzip -qo "$tmp/$archive" -d "$tmp"
  mkdir -p "$HOME/.bun/bin"
  install -m 755 "$tmp/bun-${os}-${bun_arch}/bun" "$HOME/.bun/bin/bun"
  rm -rf "$tmp"
  export PATH="$HOME/.bun/bin:$PATH"
  green "done"
  dim "  Add ~/.bun/bin to your PATH (restart your shell)"
}

main() {
  echo ""
  echo "Setting up pedromadruga.com development environment"
  echo ""

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

  echo ""
  green "Ready! Run 'hugo serve -D' to start the dev server."
  echo ""
}

# Run from repo root
cd "$(dirname "$0")/.."
main
