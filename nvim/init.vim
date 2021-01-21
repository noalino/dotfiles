"""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""
" Set UTF-8 as standard encoding
set encoding=utf-8

" Use Unix as the standard file type (handle EOL)
set ffs=unix,dos,mac

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" Color theme
Plug 'ayu-theme/ayu-vim'

" Custom status line
Plug 'itchyny/lightline.vim'

" Show git branch name in status line
Plug 'itchyny/vim-gitbranch'

" File tree explorer
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Show git diff
Plug 'airblade/vim-gitgutter'

" Autocompletion & Intellisense
Plug 'neoclide/coc.nvim'

" Linter
Plug 'dense-analysis/ale'

" Full languages support for syntax highlighting
Plug 'sheerun/vim-polyglot'

" Auto insert & delete brackets (& similar) in pairs
Plug 'jiangmiao/auto-pairs'

" Emmet
Plug 'mattn/emmet-vim'

" (Un)comment easily
Plug 'tpope/vim-commentary'

" Multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Markdown previewer
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" neomake
Plug 'neomake/neomake'

" Automacially calls 'syntax on' & 'filetype plugin indent on'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""
" Insert spaces when hitting Tab
set expandtab

" Be smart when using tabs
set smarttab

" Default to 1 tab == 2 spaces (language-specific configs are in nvim/after/ftplugin/{language}.vim file)
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent

"""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors

" Set colorscheme
let ayucolor="dark"
colorscheme ayu

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Always show current position (line & column number in status line)
set ruler

" Show line numbers on the left side of vim
set nu

" Too heavy when rendered inside container
"set cursorcolumn
set cursorline

" Add a bit extra margin to the left
set foldcolumn=1

"""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin-specific config
"""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
" Map NERDTree toggle
nnoremap <C-n> :NERDTreeToggle<CR>

" Close Vim window if NERDTree is the only one left open
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" GitGutter
" Show git diff in status line
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

" Lightline
" Custom status bar color
let g:lightline = {
    \ 'colorscheme': 'ayu',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'gitdiff' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name',
    \   'gitdiff': 'GitStatus',
    \ },
    \ }

" Hide Vim mode (as it is shown from lightline)
set noshowmode
