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
```

## Vim Plugins

```bash
mkdir -p ~/.vim/pack/plugins/opt
cd ~/.vim/pack/plugins/opt
git clone git@github.com:tpope/vim-sensible.git
git clone git@github.com:kien/ctrlp.vim.git
git clone git@github.com:christoomey/vim-tmux-navigator.git
git clone git@github.com:christoomey/vim-tmux-runner.git
git clone git@github.com:tpope/vim-rails.git
git clone git@github.com:dense-analysis/ale.git
git clone git@github.com:tpope/vim-surround.git
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