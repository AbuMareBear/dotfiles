#!/usr/bin/env bash
#
# PreToolUse hook for the Edit / Write / MultiEdit tools.
#
# Your real Claude config and shell dotfiles live in this repo and are
# symlinked into place (~/.claude/settings.json, ~/.claude/CLAUDE.md, ~/.zshrc,
# ~/.vimrc, ...). Editing one of those files in place from some *other* project
# silently writes — and would commit — a dotfiles change from the wrong repo.
#
# This hook resolves the target path through symlinks. If it lands inside the
# dotfiles repo AND the current working directory is NOT the dotfiles repo, it
# denies the edit with a reason that steers the change back to dotfiles. Edits
# made *from* the dotfiles repo (where they belong) pass through silently, as do
# all non-dotfiles files.
set -uo pipefail

DOTFILES="$HOME/code/personal/dotfiles"

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // ""')"

[ -z "$file" ] && exit 0

# Resolve symlinks to the real file location. macOS realpath has no -m, so for a
# not-yet-existing file (a fresh Write) resolve the parent dir and re-attach the
# basename.
if [ -e "$file" ]; then
  resolved="$(realpath "$file" 2>/dev/null)"
else
  rdir="$(realpath "$(dirname "$file")" 2>/dev/null)"
  resolved="${rdir:+$rdir/$(basename "$file")}"
fi
[ -z "$resolved" ] && exit 0

# Real location of the dotfiles repo itself (guard against it being symlinked).
dotreal="$(realpath "$DOTFILES" 2>/dev/null)"
[ -z "$dotreal" ] && exit 0

# Not a dotfiles-owned file -> allow.
case "$resolved" in
  "$dotreal"/*) ;;
  *) exit 0 ;;
esac

# Already working from the dotfiles repo -> editing it here is correct, allow.
cwdreal="$(realpath "$cwd" 2>/dev/null)"
case "$cwdreal" in
  "$dotreal" | "$dotreal"/*) exit 0 ;;
esac

# Dotfiles-owned file being edited from another project -> steer to dotfiles.
jq -n --arg f "$file" --arg r "$resolved" --arg d "$dotreal" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: ("This file resolves into your dotfiles repo (\($r)); editing it from the current project would silently make — and commit — a dotfiles change from the wrong repo. Make this change from the dotfiles repo instead: tell the user it belongs in dotfiles and have them open a session in \($d) (or cd there) so the edit is reviewed and committed in dotfiles. Requested path: \($f).")
  }
}'
exit 0
