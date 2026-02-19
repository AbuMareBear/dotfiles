set encoding=utf-8

" Plugins
packadd vim-sensible
packadd vim-tmux-navigator
packadd fzf
packadd fzf.vim
packadd ale
packadd vim-slim
packadd vim-gitgutter
packadd vim-rails
packadd typescript-vim
packadd vim-jsx-pretty

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

set clipboard=unnamed

set textwidth=80
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
  \ 'javascriptreact': ['eslint'],
  \ 'typescript': ['tsserver', 'eslint'],
  \ 'typescriptreact': ['tsserver', 'eslint'],
  \ }

let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'ruby': ['rubocop'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'javascriptreact': ['prettier', 'eslint'],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'typescriptreact': ['prettier', 'eslint'],
  \ 'json': ['prettier'],
  \ 'css': ['prettier'],
  \ }

let g:ale_fix_on_save = 1

" Code actions and imports via tsserver
nnoremap <leader>. :ALECodeAction<CR>
nnoremap <leader>i :ALEImport<CR>
nnoremap <leader>oi :ALEOrganizeImports<CR>

" Keep JSX closing bracket on same line as last attribute (match Prettier default)
let g:ale_javascript_prettier_options = '--bracket-same-line'
let g:ale_typescriptreact_prettier_options = '--bracket-same-line'
let g:ale_javascriptreact_prettier_options = '--bracket-same-line'
let g:ale_typescript_prettier_options = '--bracket-same-line'

" Only run linters explicitly defined in ale_linters
let g:ale_linters_explicit = 1

" Use bundle exec when available
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_ruby_standardrb_executable = 'bundle'

" Auto-detect Ruby linter based on project files
function! DetectRubyLinter()
  if filereadable('.standard.yml') || filereadable('.standardrb.yml')
    let b:ale_linters = {'ruby': ['standardrb']}
    let b:ale_fixers = {'ruby': ['standardrb']}
  elseif filereadable('.rubocop.yml')
    let b:ale_linters = {'ruby': ['rubocop']}
    let b:ale_fixers = {'ruby': ['rubocop']}
  endif
endfunction

autocmd BufRead,BufNewFile *.rb call DetectRubyLinter()
autocmd BufRead,BufNewFile *.rake call DetectRubyLinter()
autocmd BufRead,BufNewFile Gemfile call DetectRubyLinter()
autocmd BufRead,BufNewFile Rakefile call DetectRubyLinter()

" Also detect Ruby linter for files with Ruby shebang
autocmd BufRead,BufNewFile * if getline(1) =~# '^#!.*ruby' | call DetectRubyLinter() | endif

" FZF configuration - use bottom split instead of popup
let g:fzf_layout = { 'down': '40%' }

" FZF key bindings
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>f :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Files<CR>
nnoremap <leader>r :Rg<CR>

" Quick project-wide search
nnoremap <leader>s :grep -r "\<<cword>\>" .<CR>:copen<CR>

" GitGutter configuration
set updatetime=100
set signcolumn=yes

" Auto-reload files when changed externally
set autoread
autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * checktime

let g:gitgutter_map_keys = 0
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>
nnoremap ]h :GitGutterNextHunk<CR>
nnoremap [h :GitGutterPrevHunk<CR>

" GitGutter custom colors
highlight GitGutterAdd    guifg=#00ff00 ctermfg=46
highlight GitGutterChange guifg=#ffff00 ctermfg=226
highlight GitGutterDelete guifg=#ff0000 ctermfg=196


" Send text to Claude in tmux
function! SendToTmuxClaude() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')

  " Yank the selected text into the " register
  normal! gvy

  " Get the text
  let selected_text = getreg('"')

  " Send to tmux
  call system("tmux send-keys -t '{left-of}' 'Claude: ```' Enter")
  call system("tmux send-keys -t '{left-of}' " . shellescape(selected_text))
  call system("tmux send-keys -t '{left-of}' Enter '```' Enter")
  call system("tmux select-pane -L")

  " Restore the register
  call setreg('"', old_reg, old_regtype)
endfunction

vnoremap <leader>c :call SendToTmuxClaude()<CR>

" Swap windows right/left with space+wr and space+wl
nnoremap <leader>wr <C-w>r
nnoremap <leader>wl <C-w>R
