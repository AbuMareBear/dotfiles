set encoding=utf-8

" Plugins
packadd vim-sensible
packadd vim-tmux-navigator
packadd fzf
packadd fzf.vim
packadd ale
packadd vim-slim

" Add Homebrew-installed FZF to runtime path (macOS)
set rtp+=/opt/homebrew/opt/fzf

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

" ALE configuration
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_linters = {
  \ 'ruby': ['rubocop'],
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint'],
  \ }

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'ruby': ['rubocop'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'json': ['prettier'],
  \ 'css': ['prettier'],
  \ }

let g:ale_fix_on_save = 1

" FZF key bindings
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>r :Rg<CR>
