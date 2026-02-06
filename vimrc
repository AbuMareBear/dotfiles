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

" Inline git blame (virtual text on current line, like GitLens)
let g:git_blame_enabled = 1

highlight GitBlameVirtual ctermfg=60 guifg=#6272a4

function! GitBlameClear()
  silent! call prop_remove({'type': 'git_blame', 'all': v:true})
endfunction

function! GitBlameShow()
  call GitBlameClear()
  if !g:git_blame_enabled
    return
  endif
  let l:file = expand('%:p')
  if empty(l:file) || !filereadable(l:file)
    return
  endif
  let l:line = line('.')
  let l:blame = system('git -C ' . shellescape(expand('%:p:h')) . ' blame -L ' . l:line . ',' . l:line . ' --porcelain -- ' . shellescape(l:file) . ' 2>/dev/null')
  if v:shell_error
    return
  endif
  let l:lines = split(l:blame, '\n')
  let l:author = ''
  let l:time = 0
  let l:summary = ''
  let l:hash = matchstr(l:lines[0], '^\x\+')
  for l:ln in l:lines
    if l:ln =~# '^author ' && l:ln !~# '^author-'
      let l:author = substitute(l:ln, '^author ', '', '')
    elseif l:ln =~# '^author-time '
      let l:time = str2nr(substitute(l:ln, '^author-time ', '', ''))
    elseif l:ln =~# '^summary '
      let l:summary = substitute(l:ln, '^summary ', '', '')
    endif
  endfor
  if l:hash =~# '^0\+$'
    let l:text = '  Not committed yet'
  else
    let l:diff = localtime() - l:time
    if l:diff < 60
      let l:ago = 'just now'
    elseif l:diff < 3600
      let l:ago = (l:diff / 60) . ' mins ago'
    elseif l:diff < 86400
      let l:ago = (l:diff / 3600) . ' hours ago'
    elseif l:diff < 2592000
      let l:ago = (l:diff / 86400) . ' days ago'
    elseif l:diff < 31536000
      let l:ago = (l:diff / 2592000) . ' months ago'
    else
      let l:ago = (l:diff / 31536000) . ' years ago'
    endif
    let l:text = '  ' . l:author . ', ' . l:ago . ' · ' . l:summary
  endif
  call prop_add(l:line, 0, {'type': 'git_blame', 'text': l:text, 'text_align': 'after'})
endfunction

function! GitBlameToggle()
  let g:git_blame_enabled = !g:git_blame_enabled
  if !g:git_blame_enabled
    call GitBlameClear()
  endif
endfunction

if has('textprop')
  silent! call prop_type_delete('git_blame')
  call prop_type_add('git_blame', {'highlight': 'GitBlameVirtual'})
endif

augroup GitBlame
  autocmd!
  autocmd CursorMoved * call GitBlameClear()
  autocmd CursorHold * call GitBlameShow()
augroup END

nnoremap <leader>bl :call GitBlameToggle()<CR>

" Open current line's commit on GitHub
function! GitBlameOpenCommit()
  let l:file = expand('%:p')
  if empty(l:file) || !filereadable(l:file)
    return
  endif
  let l:line = line('.')
  let l:hash = system('git -C ' . shellescape(expand('%:p:h')) . ' blame -L ' . l:line . ',' . l:line . ' --porcelain -- ' . shellescape(l:file) . ' 2>/dev/null')
  let l:hash = matchstr(split(l:hash, '\n')[0], '^\x\+')
  if l:hash =~# '^0\+$'
    echo 'Not committed yet'
    return
  endif
  let l:url = system('gh browse ' . l:hash . ' -n 2>/dev/null')
  let l:url = substitute(l:url, '\n$', '', '')
  if v:shell_error || empty(l:url)
    echo 'Could not resolve GitHub URL'
    return
  endif
  call system('open ' . shellescape(l:url))
endfunction

nnoremap <leader>bo :call GitBlameOpenCommit()<CR>

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
