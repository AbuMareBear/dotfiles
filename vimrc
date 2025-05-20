set encoding=utf-8

" Plugins
packadd vim-sensible

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

" Jellybeans theme configuration
" For terminal transparency (if you want it)
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}
if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif

colorscheme jellybeans
