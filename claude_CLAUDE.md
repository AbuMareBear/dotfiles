# Global Preferences

## Voice Input

The user often dictates prompts via voice input, so transcription errors are possible — misheard words, homophones, dropped or added small words, missing punctuation, or odd phrasings that don't quite parse. If a request seems ambiguous or contains a word that looks like it might be a transcription artifact (especially names, technical terms, or unusual word choices), ask a clarifying question before acting rather than guessing.

## Shell tooling

Prefer `grep` (or `rg`) over `awk` for line-matching tasks. Reach for `awk` only when you actually need field-aware logic — `$N` references, `BEGIN`/`END` blocks, or arithmetic on fields. A pattern-only awk one-liner (no action block) is almost always just `grep -E '<pattern>'`.

Never combine `cd` with output redirection (`2>/dev/null`, `2>&1`, `| tail`, `>`, etc.) in a single compound command — this trips a built-in security guardrail ("path resolution bypass") that forces manual approval and can't be allowlisted. Instead, change directory in a standalone `cd` call first (the Bash tool's working directory persists across calls) or pass absolute paths, then run the redirecting command on its own.

## Git

Don't prefix git commands with `-C <path>` (or `cd <path> &&`) when already in that directory — the bare form (`git status`, `git diff`) matches common allow-list patterns; the prefixed form usually doesn't and forces a permission prompt.
