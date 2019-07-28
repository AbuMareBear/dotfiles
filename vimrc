set encoding=utf-8

" Plugins
:packadd sensible
:packadd ctrlp\.vim
:packadd vim-tmux-navigator
:packadd vim-tmux-runner
:packadd vim-rails
:packadd vim-slim

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

" CtrlP fuzzy search
" Exclude files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>
