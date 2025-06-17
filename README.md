# Abdullah Hashim's Dotfiles

## Symbolic links

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```bash
ln -sf ~/code/personal/dotfiles/zshrc ~/.zshrc
ln -sf ~/code/personal/dotfiles/gemrc ~/.gemrc
ln -sf ~/code/personal/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/code/personal/dotfiles/vimrc ~/.vimrc
ln -sf ~/code/personal/dotfiles/gitignore_global ~/.gitignore_global
ln -sf ~/code/personal/dotfiles/gitconfig ~/.gitconfig
ln -sf ~/code/personal/dotfiles/claude_settings.json ~/.claude/settings.json
mkdir -p ~/Library/Application\ Support/Claude
ln -sf ~/code/personal/dotfiles/claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
mkdir -p ~/Library/Application\ Support/Cursor/User
ln -sf ~/code/personal/dotfiles/cursor_settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf ~/code/personal/dotfiles/cursor_keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
```

## Shell Aliases

Key aliases defined in zshrc:
- `rs`: Run RSpec via bin/rspec
- `rsu`: Run RSpec excluding system specs
- `rt`: Run Rails tests
- `r`: Rails commands via bin/rails
- `b`: Bundle commands via bin/bundle

## Vim Plugins

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

## Vim Color Scheme

```bash
mkdir -p ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
```

## Vim Usage

- Space is configured as the leader key
- Based on vim-sensible for good defaults
- Includes ALE for asynchronous linting
- Slim template syntax highlighting

### FZF Integration

The configuration includes fuzzy finding with FZF for efficient file navigation.

#### Prerequisites

1. Install the FZF executable:
   ```bash
   # For macOS with Homebrew
   brew install fzf

   # For Linux
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

2. Optional: Add FZF to runtime path in vimrc if the above plugins don't work:
   ```vim
   " For macOS with Homebrew
   set rtp+=/opt/homebrew/opt/fzf
   ```

#### Key Bindings

- `Ctrl+p`: Open file finder
- `<leader>b`: Browse open buffers
- `<leader>g`: Search git files (respects .gitignore)
- `<leader>r`: Search file contents using ripgrep

### ALE Integration

The configuration includes ALE (Asynchronous Lint Engine) for real-time linting:

- Linting occurs on file save, not continuously
- Trailing whitespace is automatically removed
- Rubocop enabled for Ruby files
- Prettier and ESLint for JavaScript/TypeScript files
- Prettier for JSON and CSS
- Signs in the gutter indicate errors and warnings
- Error/warning messages show which linter reported them

## Tmux Usage

- `Ctrl+s` is the prefix key
- `Prefix + c`: Create new window
- `Prefix + -`: Split horizontally
- `Prefix + \`: Split vertically
- `Ctrl+h/j/k/l`: Navigate panes
- `Prefix + C-r`: Reload config
- `Shift+Arrow`: Resize pane small
- `Ctrl+Arrow`: Resize pane large
- `Prefix + b`: Break pane
- `Prefix + C-j`: Show session tree
- `Prefix + z`: Toggle zoom/maximize pane

### Visual Customization

The active pane is highlighted for better visibility:
- Active pane has bright blue borders
- Active pane has darker background
- Inactive panes are slightly dimmed with grey borders

### Managing Tmux Sessions

- Create a new session: `tmux new-session -s project_name -c /path/to/project`
- Create a new session from within tmux: Same command as above
- Switch to another session from within tmux: `tmux switch-client -t project_name`
- List all sessions: `tmux list-sessions` or `tmux ls`
- Attach to an existing session: `tmux attach -t project_name`
