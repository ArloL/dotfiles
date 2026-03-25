#!/bin/sh

set -o errexit
set -o nounset

input=$(cat)

NOW=$(date +%s)

# "// empty" produces no output when rate_limits is absent
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
WINDOW=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
FIVE_H_RESETS=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
FIVE_H_RESETS_DIFF=$((FIVE_H_RESETS - NOW))
[ "$FIVE_H_RESETS_DIFF" -lt 0 ] && FIVE_H_RESETS_DIFF=0

LIMITS=""
[ -n "$WINDOW" ] && LIMITS="${LIMITS:+$LIMITS }cw:$(printf '%.0f' "$WINDOW")%"
[ -n "$FIVE_H" ] && LIMITS="${LIMITS:+$LIMITS }5h:$(printf '%.0f' "$FIVE_H")%"
[ -n "$FIVE_H_RESETS_DIFF" ] && LIMITS="${LIMITS:+$LIMITS }5hr:$(printf '%dh%02dm\n' $((FIVE_H_RESETS_DIFF/3600)) $(((FIVE_H_RESETS_DIFF%3600)/60)))"
[ -n "$WEEK" ] && LIMITS="${LIMITS:+$LIMITS }7d:$(printf '%.0f' "$WEEK")%"

[ -n "$LIMITS" ] && echo "$LIMITS" || echo ""
