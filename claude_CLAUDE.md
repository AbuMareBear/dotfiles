# Global Preferences

## Voice Input

The user often dictates prompts via voice input, so transcription errors are possible — misheard words, homophones, dropped or added small words, missing punctuation, or odd phrasings that don't quite parse. If a request seems ambiguous or contains a word that looks like it might be a transcription artifact (especially names, technical terms, or unusual word choices), ask a clarifying question before acting rather than guessing.

## Shell tooling

For pattern searches across files, use the built-in Grep tool rather than shelling out to `rg`/`grep` in Bash — it is ripgrep under the hood, never triggers a permission prompt, and returns structured results. Only shell out to `rg` (now allow-listed) when you genuinely need something the Grep tool can't express, like piping matches into another command.

For line-matching, prefer `grep`/`rg` over `awk`. Reach for `awk` only when you actually need field-aware logic — `$N` references, `BEGIN`/`END` blocks, or arithmetic on fields. A pattern-only awk one-liner (no action block) is almost always just `grep -E '<pattern>'`. `awk` is not allow-listed (and a blanket `Bash(awk:*)` would be a broader grant than the read-only tools, since awk can `system(...)` and `print > file`), so an awk command always forces a prompt.

To extract a section or line-range from a file (e.g. one block of a YAML/config file, "from this line until the next top-level key"), don't reach for a flag-based `awk` range script — use the Read tool, the Grep tool with `-A`/`-B`/`-C` context, or `sed -n '/start/,/end/p'` (`sed -n` is already allow-listed). These don't prompt.

Never combine `cd` with output redirection (`2>/dev/null`, `2>&1`, `| tail`, `>`, etc.) in a single compound command — this trips a built-in security guardrail ("path resolution bypass") that forces manual approval and can't be allowlisted. Instead, change directory in a standalone `cd` call first (the Bash tool's working directory persists across calls) or pass absolute paths, then run the redirecting command on its own.

Never use `find ... -exec` — it can't be auto-allowed by a `Bash(find:*)` rule and forces a prompt. To find files, use the Glob tool; to search contents, use the Grep tool; to read a found file, use the Read tool. These dedicated tools don't hit the Bash guardrails at all.

Avoid `$(...)` / backtick command substitution in Bash commands — the nested command can't be vetted against prefix permission rules and forces a manual approval prompt. Instead, run the inner command on its own first (use the Glob/Grep tools, or a standalone Bash call), then run the outer command with the explicit resolved values. (Arithmetic `$((...))` and variable `${...}` expansion are fine.)

Don't use shell loops (`for`/`while`/`until` … `do` … `done`) in Bash commands — the built-in approval heuristic flags the loop statement and the dynamic loop body can't be matched against prefix permission rules, so it always forces a manual approval prompt. Run the command once per item as separate Bash calls (working directory and shell state persist across calls), or use the Glob/Grep/Read tools to enumerate and read files instead of iterating in the shell.

Don't add decorative `echo` lines to commands — section headers like `echo "=== foo ==="` or status lines like `echo "exit: $?"`. They inject an extra sub-command that usually isn't allow-listed, forcing a permission prompt on an otherwise-clean compound. Run the real command on its own and read its output directly.

To capture the full output of a long-running command (test suites, builds) while only viewing the tail, don't pipe through `tee` (`cmd 2>&1 | tee file | tail`) — the `tee` segment is checked separately against permission rules, never matches the base command's allow rule, and forces a prompt on every run (the filename varies, so allow-listing the exact command is useless). Instead redirect (`cmd > file 2>&1`), then `tail`/Read/Grep the file in a separate call — the redirect stays inside the base command's allowed prefix and doesn't prompt. For very long runs, `run_in_background` also works: the harness captures the full output itself, no log file needed.

Don't prefix commands with env-var assignments like `GH_PAGER=cat`, `PAGER=cat`, or `GIT_PAGER=cat` — the literal prefix stops the command from matching its allow-list rule (e.g. `Bash(gh issue view:*)`), forcing a prompt on an otherwise-allowed command. They're also unnecessary: `gh` and `git` disable paging automatically when stdout isn't a TTY, which is always the case in the Bash tool. Run the bare command instead.

When an env-var assignment is genuinely needed, use only the exact prefix that is allow-listed and never stack extra assignments onto it — each added assignment changes the literal prefix and breaks matching. `Bash(ENABLE_DEV_LOGIN=true npm run dev:*)` is allow-listed, so `ENABLE_DEV_LOGIN=true npm run dev -- -p 3599` runs without a prompt, while `ENABLE_DEV_LOGIN=true PORT=3599 npm run dev` prompts. If a setting can be passed as a flag after the command (like a port via `-- -p <port>`), pass it as a flag, not as another env assignment.

To wait for a local dev server to come up, or to check whether it's responding, don't hand-roll `sleep N; curl ... http://localhost:<port>/` — no curl allow rule can cover a varying port (a trailing `:*` wildcard only matches at a word boundary, so `http://localhost:*` never matches `http://localhost:3599/`), and each new port forces a prompt. Use the allow-listed helper instead: `~/code/personal/dotfiles/claude_bin/await-localhost <port> [timeout-seconds]` polls once per second until the server responds, prints the HTTP status code, and exits non-zero on timeout (default 60s) — no separate `sleep` needed.

Don't search/read files by cramming exploration into elaborate shell one-liners (chained `&&`/`||` fallbacks, `-exec`, redirections, `cat`/`grep`/`find` pipelines). Reach for the Glob, Grep, and Read tools first — they're faster, never trip approval guardrails, and keep each step independently retryable.

## Git

Don't prefix git commands with `-C <path>` (or `cd <path> &&`) when already in that directory — the bare form (`git status`, `git diff`) matches common allow-list patterns; the prefixed form usually doesn't and forces a permission prompt.

To change branches, use `git switch <branch>` (or `git switch -c <branch>` to create one) — never `git checkout <branch>`. `git switch` is allow-listed and runs without a prompt; `checkout` always prompts because its grammar also covers the destructive file-overwrite form, which a prefix rule can't distinguish. Never pass `-f`/`--force`/`--discard-changes` to `git switch` — those discard uncommitted work and are deny-listed; if a switch is blocked by local changes, stash them or ask the user.

Don't create commits on your own. Finishing a task is not permission to commit it — wait for an explicit request (/commit, "commit this", etc.) before running git commit. The same goes for git push: only push when asked.
