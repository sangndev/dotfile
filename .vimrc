filetype plugin indent on
syntax on

let mapleader = " "
let maplocalleader = " "
let g:netrw_banner = 0

set termguicolors
set number
set relativenumber
set ai
set si
set noswapfile
set cursorline
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set hlsearch
set incsearch
set ignorecase
set smartcase
set cmdheight=1
set ttyfast
set showmatch
set noerrorbells
set novisualbell
set encoding=utf8
set numberwidth=3
set clipboard=unnamed
set shiftround
set pumheight=10
set signcolumn=yes
set updatetime=300
set timeoutlen=500
set scrolloff=10
set confirm
set nolist
set ruler
set colorcolumn=80
set regexpengine=0
set splitbelow
set splitright
set nowrap
set wildmenu
set noshowmode
set mouse=a

" ------------------------------------------------------------
"  Basic mapping
" ------------------------------------------------------------
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <silent> <leader>h :noh<cr>
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-l> <C-w>l
vnoremap <silent> < <gv
vnoremap <silent> > >gv
vnoremap <silent> K :m '<-2<cr>gv=gv
vnoremap <silent> J :m '>+1<cr>gv=gv
inoremap jk <esc>
tnoremap <esc><esc> <C-\><C-N>
nnoremap <silent> sv <C-w>v<C-w>p
nnoremap <silent> ss <C-w>s<C-w>p

" ------------------------------------------------------------
"  Plugins manager
" ------------------------------------------------------------
let s:plug_dir = expand("~/.vim/plugins")

function! s:get_repo_name(name)
  let l:split_name = split(a:name, "/")
  let l:name = l:split_name[-1]
  if l:name == "vim" || l:name == "nvim"
    let l:name = l:split_name[-2]
  endif
  return l:name
endfunction

function! s:get_plugin_dir()
  let l:dirs = glob(s:plug_dir . "/*", 0, 1)
  return filter(l:dirs, { idx, val -> isdirectory(val) })
endfunction

function! s:plug_install(repo)
  let l:name = s:get_repo_name(a:repo)
  let l:path = s:plug_dir . "/" . l:name

  if !isdirectory(l:path)
    if !isdirectory(s:plug_dir)
      call mkdir(s:plug_dir, 'p')
    endif
    execute '!git clone --depth=1 ' . a:repo . ' ' . shellescape(l:path)
  endif

  execute 'set runtimepath+=' . fnameescape(l:path)
endfunction

function! s:plug_local(path)
  let l:fullpath = s:plug_dir . path
  if isdirectory(l:fullpath)
    execute 'set runtimepath+=' . fnameescape(l:fullpath)
  else
    echo l:fullpath . " is not a valid directory"
  endif

endfunction

function! s:plug_update()
  let l:plug_dirs = s:get_plugin_dir()
  for dir in l:plug_dirs
    if isdirectory(dir . "/.git")
      echo "Updating " . dir
      call system('git -C ' . shellescape(dir) . ' pull --ff-only')
    endif
  endfor
  echomsg 'Done.'
endfunction

command! PlugUpdate call s:plug_update()

" ------------------------------------------------------------
"  Plugins installation
" ------------------------------------------------------------
call s:plug_install("https://github.com/airblade/vim-gitgutter")
call s:plug_install("https://github.com/tpope/vim-fugitive")
call s:plug_install("https://github.com/rakr/vim-one")
call s:plug_install("https://github.com/tribela/vim-transparent")
call s:plug_install("https://github.com/prabirshrestha/vim-lsp")
call s:plug_install("https://github.com/mattn/vim-lsp-settings")

" ------------------------------------------------------------
"  Colorscheme
" ------------------------------------------------------------
let g:one_allow_italics = 1
colorscheme one

hi LineNr guifg=#adadad

" ------------------------------------------------------------
"  Statusline
" ------------------------------------------------------------
set laststatus=2

let g:currentmode={
      \ 'n'  : 'NORMAL',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V·LINE',
      \ '' : 'V·BLOCK',
      \ 's'  : 'SELECT',
      \ 'S'  : 'S·LINE',
      \ '' : 'S·BLOCK',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'REPLACE',
      \ 'Rv' : 'V·REPLACE',
      \ 'c'  : 'COMMAND',
      \ 't'  : 'TERMINAL',
      \}

set statusline=

set statusline+=%#TabLineSel#
set statusline+=\ 
set statusline+=%{currentmode[mode()]}
set statusline+=\ 
set statusline+=%*
set statusline+=\ %F
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %l:%v
set statusline+=\

" ------------------------------------------------------------
"  Find
" ------------------------------------------------------------
set path+=**
set wildignore+=**/node_modules/**
set wildignore+=**/dist/**
set wildignore+=**/.git/**
set wildignore+=**/.next/**

function! FindFiles(filename)
  let error_file = tempname()
  echo error_file
  silent exe '!find . -type f -iname "*' . a:filename . '*" | xargs file | sed "s/:/:1:/" > ' . error_file
  set errorformat=%f:%l:%m
  exe "cfile " . error_file
  copen
  if line('$') == 1
    wincmd w
  endif
  call delete(error_file)
endfunction
command! -nargs=1 Find call FindFiles(<q-args>)
nmap <leader>pf :Find<space>

" ------------------------------------------------------------
"  Lsp, Autocompletion
" ------------------------------------------------------------
set completeopt+=menuone,noselect

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> grn <plug>(lsp-rename)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-b> lsp#scroll(-4)
endfunction

augroup lsp_install
  au!
  let g:lsp_fold_enabled = 0
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
inoremap <C-o> <C-x><C-o>
