# Global Preferences

## Voice Input

The user often dictates prompts via voice input, so transcription errors are possible — misheard words, homophones, dropped or added small words, missing punctuation, or odd phrasings that don't quite parse. If a request seems ambiguous or contains a word that looks like it might be a transcription artifact (especially names, technical terms, or unusual word choices), ask a clarifying question before acting rather than guessing.

## Shell tooling

For pattern searches across files, use the built-in Grep tool rather than shelling out to `rg`/`grep` in Bash — it is ripgrep under the hood, never triggers a permission prompt, and returns structured results. Only shell out to `rg` (now allow-listed) when you genuinely need something the Grep tool can't express, like piping matches into another command.

For line-matching, prefer `grep`/`rg` over `awk`. Reach for `awk` only when you actually need field-aware logic — `$N` references, `BEGIN`/`END` blocks, or arithmetic on fields. A pattern-only awk one-liner (no action block) is almost always just `grep -E '<pattern>'`.

Never combine `cd` with output redirection (`2>/dev/null`, `2>&1`, `| tail`, `>`, etc.) in a single compound command — this trips a built-in security guardrail ("path resolution bypass") that forces manual approval and can't be allowlisted. Instead, change directory in a standalone `cd` call first (the Bash tool's working directory persists across calls) or pass absolute paths, then run the redirecting command on its own.

Never use `find ... -exec` — it can't be auto-allowed by a `Bash(find:*)` rule and forces a prompt. To find files, use the Glob tool; to search contents, use the Grep tool; to read a found file, use the Read tool. These dedicated tools don't hit the Bash guardrails at all.

Avoid `$(...)` / backtick command substitution in Bash commands — the nested command can't be vetted against prefix permission rules and forces a manual approval prompt. Instead, run the inner command on its own first (use the Glob/Grep tools, or a standalone Bash call), then run the outer command with the explicit resolved values. (Arithmetic `$((...))` and variable `${...}` expansion are fine.)

Don't add decorative `echo` lines to commands — section headers like `echo "=== foo ==="` or status lines like `echo "exit: $?"`. They inject an extra sub-command that usually isn't allow-listed, forcing a permission prompt on an otherwise-clean compound. Run the real command on its own and read its output directly.

Don't search/read files by cramming exploration into elaborate shell one-liners (chained `&&`/`||` fallbacks, `-exec`, redirections, `cat`/`grep`/`find` pipelines). Reach for the Glob, Grep, and Read tools first — they're faster, never trip approval guardrails, and keep each step independently retryable.

## Git

Don't prefix git commands with `-C <path>` (or `cd <path> &&`) when already in that directory — the bare form (`git status`, `git diff`) matches common allow-list patterns; the prefixed form usually doesn't and forces a permission prompt.
