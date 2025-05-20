# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains personal dotfiles for configuring various development tools including:

- Zsh (with Oh-My-Zsh)
- Vim
- Tmux
- Git
- Ruby gems

## Installation

The dotfiles are installed by creating symbolic links from this repository to the user's home directory. The README contains the necessary commands:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s ~/code/dotfiles/zshrc ~/.zshrc
ln -s ~/code/dotfiles/bash_prompt ~/.bash_prompt
ln -s ~/code/dotfiles/bashrc ~/.bashrc
ln -s ~/code/dotfiles/gemrc ~/.gemrc
ln -s ~/code/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/code/dotfiles/vimrc ~/.vimrc
ln -s ~/code/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/code/dotfiles/gitconfig ~/.gitconfig
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
- Uses Oh-My-Zsh with the "fwalch" theme
- Sets vim as the default editor
- Contains aliases for Rails, npm, and git workflow
- Configures environment for Python (pyenv), Node.js (nvm), and other development tools

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

## Common Tasks

After making changes to the dotfiles in this repository, remember to:

1. Commit the changes to keep track of your configurations
2. If needed, update the symbolic links to reflect changes