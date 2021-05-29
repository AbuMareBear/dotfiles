# Abdullah Hashim's Dotfiles

## Symbolic links

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```bash
ln -s ~/code/dotfiles/zshrc ~/.zshrc
ln -s ~/code/dotfiles/bash_aliases ~/.bash_aliases
ln -s ~/code/dotfiles/bash_prompt ~/.bash_prompt
ln -s ~/code/dotfiles/bashrc ~/.bashrc
ln -s ~/code/dotfiles/gemrc ~/.gemrc
ln -s ~/code/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/code/dotfiles/vimrc ~/.vimrc
ln -s ~/code/dotfiles/gitignore_global ~/.gitignore_global
ln -s ~/code/dotfiles/gitconfig ~/.gitconfig
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

```base
mkdir -p ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
```
