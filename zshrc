# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Load private project aliases if they exist
[[ -f ~/.project_aliases ]] && source ~/.project_aliases

# Function to get project name (handles worktrees)
get_project_name() {
  local project_name
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)

    if [[ "$git_common_dir" == *"/.bare" ]]; then
      # Bare repo worktree setup - get parent directory name
      project_name=$(basename "${git_common_dir%/.bare}")
    elif [[ "$git_common_dir" == *"/worktrees/"* ]]; then
      # Standard git worktree - get main repo name
      local main_repo_git="${git_common_dir%/worktrees/*}"
      project_name=$(basename "${main_repo_git%/.git}")
    else
      # Regular repo
      project_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    fi
  else
    project_name=$(basename "$PWD")
  fi

  # Apply alias if one exists
  if [[ -n "${PROJECT_ALIASES[$project_name]}" ]]; then
    echo "${PROJECT_ALIASES[$project_name]}"
  else
    echo "$project_name"
  fi
}

# Override robbyrussell prompt to use project name instead of directory
PROMPT='%(?:%{%F{green}%}➜ :%{%F{red}%}➜ ) '
PROMPT+='%{%F{cyan}%}$(get_project_name)%{%f%} $(git_prompt_info)'

# ASDF setup - load after Oh My Zsh
. "$HOME/.asdf/asdf.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# ASDF shims
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias g="git"
alias r="bin/rails"
alias b="bin/bundle"
alias rt="bin/rails test"
alias n="npm run"
alias p="npx prisma"
alias kill3000="kill -9 $(lsof -i :3000 -t)"
alias rs='bin/rspec'
alias rsu='bin/rspec --exclude-pattern "spec/system/*_spec.rb"'
alias two="git checkout main && git pull && bundle && yarn && bin/rails dev:prime && bin/dev"
alias forg="git checkout staging && git pull && npm i && n reset-dev && n dev"
alias lus="git checkout staging && git pull && npm i && n reset-dev && n dev"
alias forge-promote="git checkout staging && git push origin staging && git checkout main && git merge staging --ff-only && git push origin main"

# Git safety function - prevents force push without --force-with-lease
git() {
    # Check for -f or --force (but not --force-with-lease)
    if [[ "$*" == *"push"* ]] && [[ "$*" =~ (^| )(-f|--force)($| ) ]] && [[ ! "$*" =~ "--force-with-lease" ]]; then
        echo "❌ Error: 'git push -f' is disabled. Use 'git push --force-with-lease' instead."
        return 1
    fi
    command git "$@"
}

export DISABLE_SPRING=true
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export DISABLE_AUTOUPDATER=1

# Add npm global bin to PATH
export PATH=~/.npm-global/bin:$PATH

# Add local bin to PATH
export LOCAL_BIN_PATH="$HOME/.local/bin"
export PATH="$PATH:$LOCAL_BIN_PATH"

# Increase file handle limit for development
ulimit -n 1024

# Add PostgreSQL to PATH
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
# Fix for tmux-navigation
if [[ $TERM == *"tmux"* ]]; then
  infocmp tmux-256color > /dev/null 2>&1 && export TERM=tmux-256color
fi

# Disable terminal bell
set bell-style none

# Cursor configuration for better visibility
# Set cursor to blinking block
echo -ne '\e[1 q'

# Set cursor color (bright white/cyan for visibility)
echo -ne '\e]12;cyan\a'

# Reduce Ruby warnings
export RUBYOPT="-W0"
