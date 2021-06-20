" PREREQUISITES
" - Neovim
" - Vim Plug
" - Create symlink for coc-settings.json in $HOME/.config/nvim
" - FZF
" - Ripgrep
" - BAT
" - Watchman in $PATH (to update imports on file rename)
" ----------------------------------------------------------------------------------------------------------------
set encoding=utf-8          " Set UTF-8 as standard encoding format
set ffs=unix,dos,mac        " Use Unix as the standard file type
if has('termguicolors')     " Enable more vivid colors
  set termguicolors
endif
set guicursor=			      " Reset gui cursor styling
set relativenumber		    " Show line numbers relative to cursor position
set nu				            " Show line number from cursor position
" set foldcolumn=1
" set cursorline		      " Highlight current line
" -----------------------
" It always insert spaces instead of tabs
" like this, there is no issue when tabstop & shiftwidth values change
set tabstop=2
set shiftwidth=2
set expandtab
" -----------------------
set nowrap
" set ignorecase
" set smartcase
set scrolloff=8			        " Offset of 8 lines when scrolling
set splitright
set splitbelow
set noshowmode			        " Hide Vim mode, as it is handled by Lightline
" set cmdheight=2			        " Set command line height
" set nohlsearch			      " Remove highlight when searching for occurences
" augroup vimrc-incsearch-highlight	" Show highlight only when searching
"   autocmd!
"   autocmd CmdlineEnter /,\? :set hlsearch
"   autocmd CmdlineLeave /,\? :set nohlsearch
" augroup END
set noswapfile			        " Disable swap files, created when editing a file
set updatetime=100		      " Set update time (default to 4000ms), it should improve lagging UX
" set shortmess+=c		      " Don't pass messages to |ins-completion-menu|
" set backspace=indent,eol,start	" To make backspace work properly (?)

let mapleader = ","

" ----------------------------------------------------------------------------------------------------------------
" ----------------------------------------------- PLUGINS --------------------------------------------------------

" Automatically execute 'syntax on' & 'filetype plugin indent on'
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Debugger?

" Fuzzy finding
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" NERDTree to show directory (to be replaced by ranger.vim?)
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Theme
Plug 'sainnhe/sonokai'
Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'

call plug#end()

" ----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------ WINDOWS -------------------------------------------------------

" Move between windows
nnoremap <Leader>h :wincmd h<CR>
nnoremap <Leader>j :wincmd j<CR>
nnoremap <Leader>k :wincmd k<CR>
nnoremap <Leader>l :wincmd l<CR>

" Windows size modification
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

" ----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------ THEME ---------------------------------------------------------

" The configuration options should be placed before `colorscheme sonokai`.
"let g:sonokai_style = 'andromeda'
let g:sonokai_style = 'atlantis'
"let g:sonokai_enable_italic = 1
"let g:sonokai_disable_italic_comment = 1

colorscheme sonokai

let g:lightline = {
    \ 'colorscheme': 'sonokai',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'gitdiff' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'GitBranch',
    \   'gitdiff': 'GitStatus',
    \   'filetype': 'MyFiletype',
    \   'fileformat': 'MyFileformat',
    \ },
    \ }

function! GitBranch()
  return printf(' %s', FugitiveHead())
endfunction

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
  
function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" TODO set in specific golang file
" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
" Status line types/signatures
let g:go_auto_type_info = 1

" ----------------------------------------------------------------------------------------------------------------
" ----------------------------------------------- EDITING --------------------------------------------------------

" Fast saving
nmap <Leader>w :w!<CR>
" :W sudo saves files
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Sources confg file of Nvim. Useful only when testing init.vim changes
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Toggle search highlight
nnoremap <F3> :set hlsearch!<CR>

" Comment with Ctrl-/
noremap <C-_> :Commentary<CR>

" ----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------- COC ----------------------------------------------------------

" coc config
let g:coc_global_extensions = [
  \ 'coc-eslint', 
  \ 'coc-json', 
  \ 'coc-pairs',
  \ 'coc-prettier', 
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-yaml',
  \ ]

" Use TAB as completion (just like VSCode)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" ----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------- FZF ----------------------------------------------------------

" Add prefix to FZF commands, to avoid any issue
let g:fzf_command_prefix = 'Fzf'

function! CreateCenteredFloatingWindow()
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let s:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
  call nvim_open_win(s:buf, v:true, opts)
  set winhl=Normal:Floating
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
" Add border to floating window
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" Include hidden files when searching
" let $FZF_DEFAULT_COMMAND = 'rg --hidden ""'

" Default search for files in current directory
" nnoremap <C-p> :FZF<CR>
" Add preview
nnoremap <C-p> :FzfFiles<CR>

" Search inside the current directory files
nnoremap <Leader>f :FzfRg<CR>

" Search for word under cursor (search word)
nnoremap <Leader>F :FzfRg <C-R>=expand("<cword>")<CR><CR>

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" ----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------- NERDTree ----------------------------------------------------------

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['.git', 'node_modules']
let g:NERDTreeStatusline = ''

nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFocus<CR>
" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-f> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
