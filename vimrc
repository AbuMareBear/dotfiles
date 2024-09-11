set encoding=utf-8

" Plugins
:packadd sensible
:packadd ctrlp\.vim
:packadd vim-tmux-navigator
:packadd vim-tmux-runner
:packadd vim-rails
:packadd ale
:packadd vim-surround
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

set textwidth=81
set colorcolumn=+1

nmap <leader>g :tabe Gemfile<cr>
nmap <leader>r :tabe config/routes.rb<cr>
nmap <leader>l :tabe config/locales/en.yml<cr>

set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark
" colorscheme deus
let g:deus_termcolors=256

" CtrlP fuzzy search
" Exclude files in .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Indent these HTML tags too
let g:html_indent_inctags = 'p'

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" grep files under version control
command -nargs=1 Hol noautocmd vimgrep /<args>/ `git ls-files`

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

highlight StatusLine   cterm=NONE ctermfg=White ctermbg=Black gui=NONE guifg=White guibg=Black
highlight StatusLineNC cterm=NONE ctermfg=White ctermbg=Black gui=NONE guifg=Black guibg=Black

let g:ale_linters = {
\   'ruby': ['standard'],
\}
