#!/usr/bin/env bash
#
# PreToolUse hook for the Bash tool.
#
# Denies the command shapes that trip Claude Code's built-in approval
# guardrails, so Claude is told to reformulate automatically instead of
# surfacing a manual-approval prompt to the user:
#
#   1. A command that combines `cd` with output redirection (>, 2>, |, ...)
#      -> "path resolution bypass" guardrail.
#   2. Any use of `find ... -exec` / `-execdir`
#      -> can't be auto-allowed by a Bash(find:*) prefix rule.
#   3. $(...) or backtick command substitution
#      -> the nested command can't be vetted against prefix permission rules.
#   4. for / while / until shell loops
#      -> the built-in approval heuristic flags the loop statement and a
#         dynamic loop body can't be matched against prefix permission rules.
#
# On a match it prints a PreToolUse "deny" decision with a reason that steers
# Claude toward the correct reformulation. On no match it stays silent and the
# normal permission flow continues.
set -uo pipefail

input="$(cat)"
raw="$(printf '%s' "$input" | jq -r '.tool_input.command // ""')"

# Flatten newlines to spaces so a multi-line quoted string (e.g. a multi-line
# commit message) is treated as a single span rather than matched per-line.
flat="$(printf '%s' "$raw" | tr '\n' ' ')"

# noquotes: contents of BOTH single- and double-quoted strings removed. Used
# for the cd / find / redirection checks, whose operators are inert as quoted
# argument text (commit messages, echo strings, find -path globs, the <email>
# in a Co-Authored-By trailer) and so must not cause false positives.
noquotes="$(printf '%s' "$flat" | sed -E 's/"[^"]*"//g; '"s/'[^']*'//g")"

# nosingle: only single-quoted contents removed. Used for command substitution,
# which is LITERAL inside single quotes but ACTIVE inside double quotes — so a
# double-quoted "$(...)" must still be caught.
nosingle="$(printf '%s' "$flat" | sed -E "s/'[^']*'//g")"

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

# --- Pattern 3: $(...) or backtick command substitution ---
# Match $( not followed by another ( so arithmetic $((...)) is excluded; ${...}
# variable expansion never matches since it is ${ not $(. Backticks are command
# substitution wherever they appear outside single quotes.
if printf '%s' "$nosingle" | grep -Eq '\$\([^(]' \
   || printf '%s' "$nosingle" | grep -q '`'; then
  deny "This command uses \$(...) / backtick command substitution, which can't be vetted against prefix permission rules and forces a manual approval prompt. Reformulate: run the inner command on its own first (use the Glob/Grep tools, or a standalone Bash call), then run the outer command with the explicit resolved values instead of substituting them inline."
fi

# --- Pattern 2: find ... -exec / -execdir ---
if printf '%s' "$noquotes" | grep -Eq '(^|[^[:alnum:]._/-])find[[:space:]]' \
   && printf '%s' "$noquotes" | grep -Eq '[[:space:]]-exec(dir)?[[:space:]]'; then
  deny "This command uses \`find -exec\`, which can't be auto-allowed by a Bash(find:*) rule and forces a manual approval prompt. Reformulate without find -exec: use the Glob tool to locate files, the Grep tool to search contents, and the Read tool to read them. If you must use find, run it without -exec and process the paths in a separate step."
fi

# --- Pattern 1: cd combined with output redirection in one command ---
has_cd=false
if printf '%s' "$noquotes" | grep -Eq '(^|[^[:alnum:]._-])cd[[:space:]]'; then
  has_cd=true
fi

has_redir=false
# Any > redirection: >, >>, 2>, &>, 2>&1, ...
if printf '%s' "$noquotes" | grep -q '>'; then
  has_redir=true
fi
# A real pipe, but not a logical || operator.
stripped="${noquotes//||/}"
if [[ "$stripped" == *"|"* ]]; then
  has_redir=true
fi

if [[ "$has_cd" == true && "$has_redir" == true ]]; then
  deny "This command combines \`cd\` with output redirection (>, 2>, |, etc.), which trips a built-in security guardrail (\"path resolution bypass\") and forces a manual approval prompt. Reformulate: run \`cd <path>\` as its own separate Bash call first (the working directory persists across calls), or pass absolute paths, then run the redirecting command on its own."
fi

# --- Pattern 4: for / while / until shell loops ---
# Match a for/while/until keyword at command position paired with a `do` keyword
# (for ((...)); do ...; done, for f in ...; do ...; done, while ...; do ...). The
# do requirement keeps words like git "for-each-ref" or a stray "while" argument
# from matching, and quoted occurrences are already stripped from noquotes.
if printf '%s' "$noquotes" | grep -Eq '(^|[^[:alnum:]._-])(for|while|until)[[:space:]].*[[:space:];(]do([[:space:];]|$)'; then
  deny "This command uses a shell loop (for/while/until), which the built-in approval heuristic flags as a loop statement and whose dynamic body can't be matched against prefix permission rules, forcing a manual approval prompt. Reformulate without a loop: run the command once per item as separate Bash calls (the working directory and shell state persist across calls), or use the Glob/Grep/Read tools to enumerate and read files instead of iterating in the shell."
fi

# No match: stay silent so the normal permission flow applies.
exit 0
