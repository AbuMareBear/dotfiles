set encoding=utf-8

" Plugins
packadd vim-sensible
packadd vim-tmux-navigator
packadd fzf
packadd fzf.vim

" Basic settings
let mapleader = " "

set nobackup
set nowritebackup
set noswapfile

set number
set numberwidth=5

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set textwidth=81
set colorcolumn=+1

" Color settings
set background=dark
syntax on

colorscheme jellybeans

" FZF key bindings
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>r :Rg<CR>
