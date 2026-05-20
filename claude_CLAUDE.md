# Global Preferences

## Voice Input

The user often dictates prompts via voice input, so transcription errors are possible — misheard words, homophones, dropped or added small words, missing punctuation, or odd phrasings that don't quite parse. If a request seems ambiguous or contains a word that looks like it might be a transcription artifact (especially names, technical terms, or unusual word choices), ask a clarifying question before acting rather than guessing.

## Shell tooling

Prefer `grep` (or `rg`) over `awk` for line-matching tasks. Reach for `awk` only when you actually need field-aware logic — `$N` references, `BEGIN`/`END` blocks, or arithmetic on fields. A pattern-only awk one-liner (no action block) is almost always just `grep -E '<pattern>'`.
