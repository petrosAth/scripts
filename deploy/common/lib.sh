#!/usr/bin/env sh
# Shared helpers for the cross-platform deployer. POSIX sh; source, do not run.
#
#   . "$(dirname "$0")/../common/lib.sh"
#
# Honours DRY_RUN=1 to print commands instead of executing them.

# --- Colored status output ---------------------------------------------------
# Decide once whether to colorize: NO_COLOR disables, FORCE_COLOR/CLICOLOR_FORCE
# force it on even when piped, otherwise emit only when stderr is a terminal so
# logs and pipes stay clean.
_use_color=0
if [ -n "${NO_COLOR:-}" ]; then
    _use_color=0
elif [ -n "${FORCE_COLOR:-}" ] || [ -n "${CLICOLOR_FORCE:-}" ]; then
    _use_color=1
elif [ -t 2 ]; then
    _use_color=1
fi
if [ "$_use_color" -eq 1 ]; then
    _c_green=$(tput setaf 2 2> /dev/null || printf '')
    _c_yellow=$(tput setaf 3 2> /dev/null || printf '')
    _c_red=$(tput setaf 1 2> /dev/null || printf '')
    _c_bold=$(tput bold 2> /dev/null || printf '')
    _c_dim=$(tput dim 2> /dev/null || printf '')
    _c_reset=$(tput sgr0 2> /dev/null || printf '')
else
    _c_green='' _c_yellow='' _c_red='' _c_bold='' _c_dim='' _c_reset=''
fi

# Calm, restrained status lines to stderr (stdout stays for real command
# output): a single accent per state, indented to align with the completion
# sheet. In-progress lines are dim; state changes carry the color.
_process() { printf '  %s\xe2\x80\xba  %s%s\n' "$_c_dim" "$*" "$_c_reset" >&2; }
_success() { printf '  %s\xe2\x9c\x93%s  %s\n' "$_c_green" "$_c_reset" "$*" >&2; }
_warn() { printf '  %s!%s  %s\n' "$_c_yellow" "$_c_reset" "$*" >&2; }
_error() { printf '  %s\xe2\x9c\x97%s  %s\n' "$_c_red" "$_c_reset" "$*" >&2; }

# Abbreviate $HOME to ~ for display in messages.
_tilde() {
    case "$1" in
    "$HOME") printf '~\n' ;;
    "$HOME"/*) printf '~/%s\n' "${1#"$HOME"/}" ;;
    *) printf '%s\n' "$1" ;;
    esac
}

# Render a calm completion sheet to stderr: a green check, a bold headline, and
# a dim, aligned "Label  Value" list framed by whitespace. Pad the label before
# coloring so escape codes never skew alignment. Usage:
#   _complete "Deployment complete" "Platform" "$OS" "Dotfiles" "$dir"
_complete() {
    _headline=$1
    shift
    printf '\n' >&2
    printf '  %s%s\xe2\x9c\x93%s  %s%s%s\n' \
        "$_c_green" "$_c_bold" "$_c_reset" "$_c_bold" "$_headline" "$_c_reset" >&2
    printf '\n' >&2
    while [ "$#" -ge 2 ]; do
        printf '     %s%-11s%s%s\n' "$_c_dim" "$1" "$_c_reset" "$2" >&2
        shift 2
    done
    printf '\n' >&2
}

# Abort with a message and non-zero status.
die() {
    _error "$*"
    exit 1
}

# --- Platform detection ------------------------------------------------------
# Print a normalized platform token: arch | macos. Unknown systems abort.
detect_os() {
    case "$(uname -s)" in
    Linux)
        if [ -r /etc/arch-release ] || command -v pacman > /dev/null 2>&1; then
            printf 'arch\n'
        else
            die "Unsupported Linux distribution: this deployer targets Arch only."
        fi
        ;;
    Darwin)
        printf 'macos\n'
        ;;
    *)
        die "Unsupported operating system: $(uname -s)"
        ;;
    esac
}

# --- Command execution -------------------------------------------------------
# Run a command, or just print it when DRY_RUN=1. Every state-changing call in
# the deployer goes through here so a dry run prints the full sequence.
run() {
    if [ "${DRY_RUN:-0}" = "1" ]; then
        printf 'DRY_RUN: %s\n' "$*" >&2
        return 0
    fi
    "$@"
}

# --- Interactive prompts -----------------------------------------------------
# Ask a yes/no question with a bounded number of retries. Defaults to "no" at
# EOF so a non-interactive pipe can never hang (trap T8: no unbounded read).
# Usage: confirm "Question?" && ...
confirm() {
    question=$1
    attempts=0
    while [ "$attempts" -lt 3 ]; do
        printf '%s [y/N] ' "$question" >&2
        if ! read -r reply; then
            printf '\n' >&2
            return 1
        fi
        case "$reply" in
        [Yy] | [Yy][Ee][Ss]) return 0 ;;
        '' | [Nn] | [Nn][Oo]) return 1 ;;
        *) _warn "Please answer yes or no." ;;
        esac
        attempts=$((attempts + 1))
    done
    _warn "No valid answer after 3 attempts; assuming no."
    return 1
}

# --- Package-list files ------------------------------------------------------
# Print the installable entries of a list file: strip '#' comments (whole-line
# and trailing) and blank lines. One package per output line.
read_list() {
    list=$1
    [ -r "$list" ] || die "Package list not found: $list"
    sed -e 's/#.*$//' -e 's/[[:space:]]*$//' "$list" | grep -v '^[[:space:]]*$'
}
