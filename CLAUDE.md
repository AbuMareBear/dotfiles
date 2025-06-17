# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains personal dotfiles for configuring various development tools including:

- Zsh (with Oh-My-Zsh)
- Vim
- Tmux
- Git
- Ruby gems
- RSpec
- Claude
- Cursor IDE

## Installation

The dotfiles are installed by creating symbolic links from this repository to the user's home directory. The README contains the necessary commands:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s ~/code/personal/dotfiles/zshrc ~/.zshrc
ln -s ~/code/personal/dotfiles/gemrc ~/.gemrc
ln -s ~/code/personal/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/code/personal/dotfiles/vimrc ~/.vimrc
ln -s ~/code/personal/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/code/personal/dotfiles/gitconfig ~/.gitconfig
ln -s ~/code/personal/dotfiles/claude_settings.json ~/.claude/settings.json
mkdir -p ~/Library/Application\ Support/Claude
ln -s ~/code/personal/dotfiles/claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
mkdir -p ~/Library/Application\ Support/Cursor/User
ln -s ~/code/personal/dotfiles/cursor_settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -s ~/code/personal/dotfiles/cursor_keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
```

Vim plugins can be installed with:

```bash
mkdir -p ~/.vim/pack/plugins/opt
cd ~/.vim/pack/plugins/opt
git clone git@github.com:tpope/vim-sensible.git
git clone git@github.com:christoomey/vim-tmux-navigator.git
git clone git@github.com:junegunn/fzf.git
git clone git@github.com:junegunn/fzf.vim.git
git clone git@github.com:dense-analysis/ale.git
git clone git@github.com:slim-template/vim-slim.git
git clone git@github.com:airblade/vim-gitgutter.git
```

Vim colorscheme can be installed with:

```bash
mkdir -p ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
```

## Configuration Details

### Shell Configuration (zshrc)

Key aspects of the zshrc configuration:
- Uses Oh-My-Zsh with the "robbyrussell" theme
- Sets vim as the default editor
- Contains aliases for Rails, npm, and git workflow
- Configures environment for Ruby (asdf), and other development tools

### Tmux Configuration (tmux.conf)

The tmux configuration includes:
- Sets the prefix to C-s
- Configures vim-tmux-navigator for seamless navigation between panes
- Custom key bindings for splitting windows, resizing panes, and other operations
- Plugin management with tpm (Tmux Plugin Manager)

### Vim Configuration (vimrc)

The vim configuration includes:
- Space as leader key
- Custom settings for indentation, line numbers, and text width
- No backup/swap files
- Custom key mappings
- Integration with tmux
- FZF integration for fuzzy file finding (requires FZF executable to be installed via `brew install fzf` on macOS)
- ALE for asynchronous linting and fixing
- Slim template syntax highlighting
- GitGutter for showing git diff markers in the sign column

### Git Configuration (gitconfig and gitignore_global)

The gitconfig sets up:
- User information
- Vim as the default editor
- Custom aliases for git commands
- Default branch name set to "main"

The gitignore_global excludes:
- Editor files (.vscode, .idea, .swp)
- OS files (.DS_Store)
- Compiled sources and packages
- Logs and databases
- npm lock files when using yarn

### Cursor Configuration (cursor_settings.json and cursor_keybindings.json)

The Cursor settings include:
- Auto-organize imports and remove unused imports on save
- Format on save with Prettier for JS/TS files
- Tab size of 2 spaces
- Editor rulers at 80 and 120 characters
- Custom color theme adjustments
- Ruby LSP configuration with inlay hints disabled
- Disabled formatting for YAML files

The Cursor keybindings include:
- `cmd+i` - Open Composer mode agent
- `shift+enter` - Continue terminal command on new line
- `ctrl+s s` - Open recent files

## Common Tasks

After making changes to the dotfiles in this repository, remember to:

1. Commit the changes to keep track of your configurations
2. If needed, update the symbolic links to reflect changes