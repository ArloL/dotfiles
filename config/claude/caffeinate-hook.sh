#!/usr/bin/env bash
# SessionStart hook: hold a caffeinate assertion for as long as the Claude Code
# process that spawned this hook lives. -w releases it automatically on exit,
# including crashes, so no matching teardown hook is required.
# Add "d" to FLAGS to also keep the display lit.

FLAGS="-ims"

pid=$PPID
for _ in 1 2 3; do
  [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = claude ] && break
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  case "$pid" in '' | 0 | 1) exit 0 ;; esac
done

[ "$(ps -o comm= -p "$pid" 2>/dev/null)" = claude ] || exit 0
pgrep -f "caffeinate $FLAGS -w $pid\$" >/dev/null && exit 0

caffeinate $FLAGS -w "$pid" >/dev/null 2>&1 &
disown
