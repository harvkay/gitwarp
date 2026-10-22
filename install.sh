#!/bin/sh
# Install gitwarp into a directory on your PATH.
#
#   curl -fsSL https://raw.githubusercontent.com/harvkay/gitwarp/main/install.sh | sh
#
# Puts the script in ~/.local/bin (override with GITWARP_BIN=/some/dir) and,
# if that directory is not on your PATH yet, adds it for bash, zsh or fish.
# Needs no root. Safe to run again; it just replaces the script.

set -eu

REPO_RAW="https://raw.githubusercontent.com/harvkay/gitwarp/main"
BIN_DIR="${GITWARP_BIN:-$HOME/.local/bin}"
TARGET="$BIN_DIR/gitwarp"

say() { printf '%s\n' "$*"; }
die() { say "install.sh: $*" >&2; exit 1; }

# --- requirements ---------------------------------------------------------
command -v git >/dev/null 2>&1 || die "git is required but was not found"
command -v python3 >/dev/null 2>&1 || die "python3 is required but was not found"

# --- fetch the script -----------------------------------------------------
mkdir -p "$BIN_DIR"
tmp="$(mktemp "${TMPDIR:-/tmp}/gitwarp.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

# Running ./install.sh from a clone installs the local copy.
local_copy="$(dirname "$0")/gitwarp"
if [ -f "$0" ] && [ -f "$local_copy" ]; then
    cp "$local_copy" "$tmp"
elif command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_RAW/gitwarp" -o "$tmp"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$tmp" "$REPO_RAW/gitwarp"
else
    die "need curl or wget to download gitwarp"
fi

head -1 "$tmp" | grep -q python3 || die "downloaded file does not look like gitwarp"
chmod 755 "$tmp"
mv "$tmp" "$TARGET"
trap - EXIT
say "installed gitwarp to $TARGET"

# --- make sure it is on PATH ----------------------------------------------
case ":$PATH:" in
    *":$BIN_DIR:"*)
        say "$BIN_DIR is already on your PATH. Run: gitwarp"
        exit 0
        ;;
esac

# Write $HOME as a variable in rc files so the line survives a renamed home.
case "$BIN_DIR" in
    "$HOME"/*) rc_dir="\$HOME${BIN_DIR#"$HOME"}" ;;
    *)         rc_dir="$BIN_DIR" ;;
esac
posix_line="export PATH=\"$rc_dir:\$PATH\""

append_once() {  # append_once FILE LINE
    if [ -f "$1" ] && grep -qxF "$2" "$1"; then
        return
    fi
    printf '\n# gitwarp\n%s\n' "$2" >> "$1"
    say "added $BIN_DIR to PATH in $1"
}

shell_name="$(basename "${SHELL:-sh}")"
case "$shell_name" in
    bash)
        append_once "$HOME/.bashrc" "$posix_line"
        # macOS Terminal starts login shells, which read .bash_profile instead.
        if [ "$(uname -s)" = Darwin ]; then
            append_once "$HOME/.bash_profile" "$posix_line"
        fi
        ;;
    zsh)
        append_once "${ZDOTDIR:-$HOME}/.zshrc" "$posix_line"
        ;;
    fish)
        fish_conf="${XDG_CONFIG_HOME:-$HOME/.config}/fish/conf.d"
        mkdir -p "$fish_conf"
        append_once "$fish_conf/gitwarp.fish" "fish_add_path --global \"$rc_dir\""
        ;;
    *)
        say "$BIN_DIR is not on your PATH and I don't know how to configure $shell_name."
        say "Add this to your shell's startup file:"
        say "    $posix_line"
        exit 0
        ;;
esac

say "Open a new terminal (or re-source your shell config), then run: gitwarp"
