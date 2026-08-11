local_username="abdullah"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Re-prepend asdf shims after macOS path_helper (/etc/zprofile) demotes
# inherited PATH entries behind /usr/bin. Non-interactive login shells
# (e.g. Claude Code's Bash tool) never source .zshrc, so without this
# they resolve system Ruby instead of the asdf-managed version.
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
