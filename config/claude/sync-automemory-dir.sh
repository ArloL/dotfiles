#!/usr/bin/env bash
# Global SessionStart hook: keep auto-memory in <repo>/.claude/memory for every
# git repository, migrating any memories already written to the default location.
#
# autoMemoryDirectory cannot live in a checked-in .claude/settings.json -- Claude
# Code ignores it from project settings so that cloning a repo can't redirect
# where your memories get written. Hence the detour through the gitignored
# settings.local.json, rewritten every session so the absolute path self-heals
# when a repo is moved or re-cloned elsewhere.
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

root="${CLAUDE_PROJECT_DIR:-}"
[ -n "$root" ] || root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$root" ] || root="$PWD"
root="$(cd "$root" 2>/dev/null && pwd -P)" || exit 0

# $HOME holds ~/.claude, so it would satisfy the signal test below and turn the
# whole home directory into a "project". It never is one.
[ "$root" = "$(cd "$HOME" && pwd -P)" ] && exit 0

# Gate on evidence that this directory is something you drive with Claude, not
# on it being a git repo: the projects worth keeping memories for include plain
# directories, while a throwaway clone with no Claude config wants none. After
# the first run this is self-satisfied, since the hook writes .claude itself.
claude_project=""
for signal in CLAUDE.md AGENTS.md .claude; do
    [ -e "$root/$signal" ] && { claude_project=1; break; }
done
[ -n "$claude_project" ] || exit 0

target="$root/.claude/memory"
settings="$root/.claude/settings.local.json"

# Plain newline-joined string rather than an array: macOS ships bash 3.2, where
# expanding an empty array under `set -u` aborts the script.
notes=""
note() { notes="${notes}$1"$'\n'; }

# --- migrate memories out of the default per-project location -----------------
# The default is ~/.claude/projects/<path with separators flattened to ->/memory.
# Compute that name forward from the known root: reversing it is ambiguous, since
# both "/" and "." flatten to "-". Two spellings are tried because the exact
# escaping rule is unverified for paths containing "_" or spaces; a candidate is
# only used if the directory actually exists.
migrate_from() {
    local src="$1" moved=0 entry
    [ -d "$src" ] || return 0
    [ "$src" = "$target" ] && return 0
    # Never overwrite memories the repo already holds -- if the target has
    # content, leave the old copy in place for manual reconciliation.
    if [ -d "$target" ] && [ -n "$(ls -A "$target" 2>/dev/null)" ]; then
        [ -n "$(ls -A "$src" 2>/dev/null)" ] && \
            note "auto-memory: $src still holds files; $target is non-empty, so nothing was moved"
        return 0
    fi
    [ -n "$(ls -A "$src" 2>/dev/null)" ] || return 0

    mkdir -p "$target"
    for entry in "$src"/* "$src"/.[!.]*; do
        [ -e "$entry" ] || continue
        mv "$entry" "$target/"
        moved=$((moved + 1))
    done
    rmdir "$src" 2>/dev/null || true
    note "auto-memory: moved $moved file(s) from $src to $target"
}

# The two spellings coincide for most paths; only visit each candidate once.
seen=""
for flat in "$(printf '%s' "$root" | tr '/.' '-')" \
            "$(printf '%s' "$root" | tr -c '[:alnum:]' '-')"; do
    case "$seen" in *"|$flat|"*) continue ;; esac
    seen="$seen|$flat|"
    migrate_from "$HOME/.claude/projects/$flat/memory"
done

# --- point settings.local.json at the repo-local directory --------------------
mkdir -p "$root/.claude"
if [ ! -f "$settings" ]; then
    jq -n --arg d "$target" \
        '{"$schema":"https://json.schemastore.org/claude-code-settings.json","autoMemoryDirectory":$d}' \
        > "$settings"
    note "auto-memory: created $settings"
elif [ "$(jq -r '.autoMemoryDirectory // empty' "$settings")" != "$target" ]; then
    tmp="$(mktemp)"
    jq --arg d "$target" '.autoMemoryDirectory = $d' "$settings" > "$tmp"
    mv "$tmp" "$settings"
    note "auto-memory: repointed $settings at $target"
fi

# settings.local.json is per-machine and holds absolute paths, so it never gets
# committed. .claude/memory deliberately does -- memories travel with the repo.
# Only meaningful under version control; a plain directory gets no stray file.
if [ -e "$root/.git" ]; then
    ignore="$root/.claude/.gitignore"
    if ! { [ -f "$ignore" ] && grep -qxF 'settings.local.json' "$ignore"; }; then
        echo 'settings.local.json' >> "$ignore"
    fi
fi

# SessionStart stdout is injected into Claude's context, so report through
# systemMessage instead and keep the transcript clean.
if [ -n "$notes" ]; then
    printf '%s' "$notes" | jq -Rsc '{systemMessage: (. | rtrimstr("\n")), suppressOutput: true}'
fi
