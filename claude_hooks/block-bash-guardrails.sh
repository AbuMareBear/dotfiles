#!/usr/bin/env bash
#
# PreToolUse hook for the Bash tool.
#
# Denies the two command shapes that trip Claude Code's built-in approval
# guardrails, so Claude is told to reformulate automatically instead of
# surfacing a manual-approval prompt to the user:
#
#   1. A command that combines `cd` with output redirection (>, 2>, |, ...)
#      -> "path resolution bypass" guardrail.
#   2. Any use of `find ... -exec` / `-execdir`
#      -> can't be auto-allowed by a Bash(find:*) prefix rule.
#
# On a match it prints a PreToolUse "deny" decision with a reason that steers
# Claude toward the correct reformulation. On no match it stays silent and the
# normal permission flow continues.
set -uo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // ""')"

# Strip the contents of single- and double-quoted strings before inspecting,
# so quoted argument text (commit messages, echo strings, find -path globs,
# the <email> in a Co-Authored-By trailer) can't cause false positives. Real
# shell operators (-exec, 2>/dev/null, | head) live outside quotes and survive.
# Newlines are flattened to spaces first so a multi-line quoted string (e.g. a
# multi-line commit message) is stripped as a single span rather than per-line.
cmd="$(printf '%s' "$cmd" | tr '\n' ' ' | sed -E 's/"[^"]*"//g; '"s/'[^']*'//g")"

deny() {
  jq -n --arg r "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

# --- Pattern 2: find ... -exec / -execdir ---
if printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]._/-])find[[:space:]]' \
   && printf '%s' "$cmd" | grep -Eq '[[:space:]]-exec(dir)?[[:space:]]'; then
  deny "This command uses \`find -exec\`, which can't be auto-allowed by a Bash(find:*) rule and forces a manual approval prompt. Reformulate without find -exec: use the Glob tool to locate files, the Grep tool to search contents, and the Read tool to read them. If you must use find, run it without -exec and process the paths in a separate step."
fi

# --- Pattern 1: cd combined with output redirection in one command ---
has_cd=false
if printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]._-])cd[[:space:]]'; then
  has_cd=true
fi

has_redir=false
# Any > redirection: >, >>, 2>, &>, 2>&1, ...
if printf '%s' "$cmd" | grep -q '>'; then
  has_redir=true
fi
# A real pipe, but not a logical || operator.
stripped="${cmd//||/}"
if [[ "$stripped" == *"|"* ]]; then
  has_redir=true
fi

if [[ "$has_cd" == true && "$has_redir" == true ]]; then
  deny "This command combines \`cd\` with output redirection (>, 2>, |, etc.), which trips a built-in security guardrail (\"path resolution bypass\") and forces a manual approval prompt. Reformulate: run \`cd <path>\` as its own separate Bash call first (the working directory persists across calls), or pass absolute paths, then run the redirecting command on its own."
fi

# No match: stay silent so the normal permission flow applies.
exit 0
