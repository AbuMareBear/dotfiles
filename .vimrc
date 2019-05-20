set encoding=utf-8

" Use the space key as leader
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

set textwidth=80
set colorcolumn=+1

nmap <leader>g :tabe Gemfile<cr>
nmap <leader>r :tabe config/routes.rb<cr>

colorscheme jellybeans

