" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if isdirectory(expand('~/go/misc/vim'))
  set rtp+=~/go/misc/vim
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Vundle auto setup {{{
let gotVundle=1
if !isdirectory(expand('~/.vim/bundle/vundle/.git'))
  echo "Installing Vundle!\n"
  if isdirectory(expand('~/.vim/bundle')) == 0
    call mkdir(expand('~/.vim/bundle'), 'p')
  endif
  execute 'silent !git clone https://github.com/gmarik/vundle "'.expand('~/.vim/bundle/vundle').'"'
  let gotVundle=0
endif
" }}

" Recursively search back to / for a tags file
set tags=./tags;/

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Let Vundle manage itself
Bundle "gmarik/vundle"

"""""""""""
" Plugins "
"""""""""""

" Vimux {{{
Bundle "benmills/vimux"
let g:VimuxUseNearestPane = 1
let g:VimuxPromptString = '$ '
nnoremap <Leader>vp :VimuxPromptCommand<CR>
nnoremap <Leader>vl :VimuxRunLastCommand<CR>
nnoremap <Leader>vi :VimuxInspectRunner<CR>
nnoremap <Leader>vq :VimuxCloseRunner<CR>
nnoremap <Leader>vx :VimuxInterruptRunner<CR>
" }}}

" Airline {{{
Bundle "vim-airline/vim-airline"
Bundle "vim-airline/vim-airline-themes"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 0
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_theme = "bubblegum"
" }}}

Bundle "christoomey/vim-tmux-navigator"

Bundle "godlygeek/tabular"

Bundle "Mixed-sourceassembly-syntax-objdump"

Bundle "Lokaltog/vim-easymotion"

" Tagbar {{{
Bundle "majutsushi/tagbar"
nnoremap <F4> <ESC>:TagbarToggle<cr>
inoremap <F4> <ESC>:TagbarToggle<cr>a
" }}}

" Undotree {{{
Bundle "mbbill/undotree"
nnoremap <F3> <ESC>:UndotreeToggle<cr>
inoremap <F3> <ESC>:UndotreeToggle<cr>a
" }}}

" Signify {{{
Bundle "mhinz/vim-signify"
let g:signify_vcs_list=['git', 'hg', 'svn']
let g:signify_sign_delete='-'

let g:signify_mapping_toggle_highlight = '<leader>sh'
let g:signify_mapping_next_hunk = '<leader>sj'
let g:signify_mapping_prev_hunk = '<leader>sk'
let g:signify_mapping_toggle = '<leader>st'
" }}}

" Unite {{{
if v:version >= 703
  Bundle "Shougo/unite.vim"
  Bundle "tsukkee/unite-tag"
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
  call unite#filters#sorter_default#use(['sorter_rank'])
  call unite#custom#source('file_mru,file_rec,file_rec/async,grep,locate',
        \ 'ignore_pattern', join(['\.git/',
                                \ 'tmp/',
                                \ 'contrib/',
                                \ 'tags',
                                \ 'build/',
                                \ 'callgrind*',
                                \ 'obj/',
                                \ 'vendor/'], '\|'))

  call unite#custom#source('file_rec,file_rec/async,grep,tag',
        \ 'smartcase', 1)
  call unite#custom#profile('default', 'context',
        \ {'prompt_direction': 'top'})
  let g:unite_source_history_yank = 1
  let g:unite_data_directory = '/tmp/unite.vim'
  let g:unite_prompt = '>>>'
  let g:unite_split_rule = 'botright'
  let g:unite_update_time = 200
  let g:unite_winheight = 15
  let g:unite_source_rec_max_cache_files = 4000

  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--smart-case --nogroup --nocolor --column'
    let g:unite_source_grep_recursive_opt = ''
  endif

  nnoremap <leader>f :Unite -start-insert -buffer-name=files file_rec/async<CR>
  nnoremap <leader>g :Unite -start-insert -buffer-name=grep grep:.<CR>
  nnoremap <leader>b :Unite -start-insert -buffer-name=buffers buffer<CR>
  nnoremap <leader>y :Unite -start-insert -buffer-name=yank history/yank<CR>
  nnoremap <leader>t :Unite -start-insert -buffer-name=tags tag<CR>

  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    " Overwrite settings.
    nmap <buffer> <ESC> <Plug>(unite_exit)
    nmap <buffer> j <Plug>(unite_select_next_line)
    nmap <buffer> k <Plug>(unite_select_previous_line)
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)
    imap <silent><buffer><expr> <C-s> unite#do_action('split')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  endfunction
endif
" }}}

Bundle "Shougo/vimproc"

Bundle "tomtom/tcomment_vim"

Bundle "tpope/vim-fugitive"

Bundle "tpope/vim-surround"

Bundle "tpope/vim-endwise"

Bundle "AndrewRadev/splitjoin.vim"

" Neocomplete/Neocomplecache {{{
if has('lua')
  Bundle "Shougo/neocomplete.vim"
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smartcase = 1
else
  Bundle "Shougo/neocomplcache.vim"
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
endif
" Tab completion
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}

" Color schemes
Bundle "tomasr/molokai"
colorscheme molokai

if gotVundle == 0
  echo "Installing Bundles!\n"
  execute "BundleInstall"
endif
" }}}

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" show tabs and line ends
set listchars=tab:→\ ,eol:¬,trail:·
set list

set nomodeline
set nobackup
set nowritebackup
set history=50 " keep 50 lines of command line history
set ruler      " show the cursor position all the time
set showcmd    " display incomplete commands
set incsearch  " do incremental searching
set smartcase
set nofoldenable

" Don't use Ex mode, use Q for formatting.
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  set ttymouse=xterm2
endif

" Switch syntax , search  and current line highlighting on
" if there are enough colour available.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set cursorline
endif

set laststatus=2   " Always show the statusline.
set encoding=utf-8 " Necessary to show Unicode glyphs.

set number
if v:version >= 740
  set relativenumber
  set breakindent
endif

"filetype plugin on
set ofu=syntaxcomplete#Complete

" Remove the annoying preview
set completeopt-=preview

if v:version >= 730
  set colorcolumn=80
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Gen4 dedupe template files
  autocmd BufRead *.tpl setlocal filetype=cpp

  autocmd BufRead,BufNewFile project.conf setlocal syntax=yaml
  autocmd BufRead,BufNewFile *.bst setlocal syntax=yaml

  " Handy stuff for sticking to PEP8 in python
  function! PEP8()
    setlocal expandtab
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal softtabstop=4
    set colorcolumn=80
  endfunction
  autocmd FileType python call PEP8()

  function! GoFmt()
    setlocal noexpandtab
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal softtabstop=4
  endfunction
  autocmd FileType go call GoFmt()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

  " Toggle relative number so it only shows in Normal & Visual mode in the
  " active split {{{
  if v:version > 740
    function! SetRelativeNumber()
      if and(&ft !=# "unite", &modifiable)
        set relativenumber
      endif
    endfunction

    autocmd BufEnter,InsertLeave * call SetRelativeNumber()
    autocmd BufLeave,InsertEnter * set norelativenumber
  endif
  " }}}
else
    set autoindent " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

" Move entire line up and down.
nnoremap <s-j> :m +1<CR>==
nnoremap <s-k> :m -2<CR>==
vnoremap <s-k> :m '<-2<CR>gv=gv
vnoremap <s-j> :m '>+1<CR>gv=gv

" Reselect block after indent.
vnoremap < <gv
vnoremap > >gv

" Set the correct escape codes for italics.
" set t_ZH=[3m
" set t_ZR=[23m

set background=dark

"Show the Subversion 'blame' annotation for the current file, in a narrow
"  window to the left of it.
"Usage:
"  'gb' or ':Blame'
"  To get rid of it, close or delete the annotation buffer.
"Bugs:
"  If the source file buffer has unsaved changes, these aren't noticed and
"    the annotations won't align properly. Should either warn or preferably
"    annotate the actual buffer contents rather than the last saved version.
"  When annotating the same source file again, it creates a new annotation
"    buffer. It should re-use the existing one if it still exists.
"Possible enhancements:
"  When invoked on a revnum in a Blame window, re-blame same file up to the
"    previous revision.
"  Dynamically synchronize when edits are made to the source file.
function! s:svnBlame()
   let line = line(".")
   " create a new window at the left-hand side
   aboveleft 18vnew
   " blame, ignoring white space changes
   %!svn blame -x -w "#" | sed 's/\(.\{,18\}\).*/\1/'
   setlocal nonumber nomodified nomodifiable readonly buftype=nofile nowrap winwidth=1
   if has('&relativenumber') | setlocal norelativenumber | endif
   " return to original line
   exec "normal " . line . "G"
   " synchronize scrolling, and return to original window
   setlocal scrollbind
   wincmd p
   setlocal scrollbind
   syncbind
endfunction
command! Blame call s:svnBlame()
