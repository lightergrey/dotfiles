syntax on

" -----------------------------------------------------------------------
" Plugins {{{
" -----------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'lightergrey/base16-vim'
Plug 'duggiefresh/vim-easydir'
Plug 'haya14busa/incsearch.vim'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'sbdchd/neoformat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'w0rp/ale'

call plug#end()

filetype plugin indent on

" }}}

" -----------------------------------------------------------------------
" Options {{{
" -----------------------------------------------------------------------
let mapleader=' '

set autoindent
set autoread
set backspace=indent,eol,start
if has('unnamedplus')
    set clipboard^=unnamedplus
endif
set complete-=i
set conceallevel=0
set display+=lastline
set encoding=utf-8
set expandtab
set foldlevel=99
set formatoptions+=j
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linebreak
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set mouse=a
set nobackup
set noswapfile
set number
set relativenumber
set ruler
set scrolloff=5
set shiftwidth=4
set showtabline=2
set smartcase
set smartindent
set smarttab
set splitbelow
set splitright
set tabpagemax=50
set tabstop=4
set termguicolors
set undodir=~/.vim/undodir
set undofile
set visualbell
set wildchar=<TAB>
set wildmenu
set wildmode=list:longest,full
set writebackup

" }}}

" -----------------------------------------------------------------------
" Autocommands  {{{
" -----------------------------------------------------------------------
" Source vimrc when saved
augroup SourceVIMRC
    autocmd!
    autocmd BufWritePost init.vim source $MYVIMRC
augroup END
" Remove extra whitespace
autocmd FileType php,js,jsx,css,scss,tpl,vim autocmd BufWritePre <buffer> %s/\s\+$//e
" Refresh buffer on focus
autocmd FocusGained,BufEnter * :silent! !
" Try relative numbers in normal mode and absolute in insert
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" }}}

" -----------------------------------------------------------------------
" Ale (linter) {{{
" -----------------------------------------------------------------------
let g:ale_fixers = { 'javascript': ['eslint'], }
let g:ale_linters = { 'javascript': ['eslint'], 'php': ['php'], }
let g:ale_sign_column_always = 1
let g:ale_sign_error = '●'
let g:ale_sign_warning = '▲'

" }}}

" -----------------------------------------------------------------------
" Colorscheme {{{
" -----------------------------------------------------------------------
colorscheme base16-oceanicnext
call matchadd('ColorColumn', '\%81v', 100)

" }}}

" -----------------------------------------------------------------------
" Deoplete {{{
" -----------------------------------------------------------------------
let g:deoplete#auto_complete_delay = 1
let g:deoplete#enable_at_startup = 1

" Use shift tab to go up in suggestion list
imap <expr><S-TAB>
    \ pumvisible()
    \     ? "\<C-p>"
    \     : "\<S-TAB>"
" Close suggestion list with return
inoremap <expr><CR>
    \ pumvisible()
    \     ? deoplete#mappings#close_popup()
    \     : "\<CR>"

" }}}

" -----------------------------------------------------------------------
" FZF - Fuzzy File {{{
" -----------------------------------------------------------------------
let g:fzf_buffers_jump = 1

" FZF Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" FZF Insert mode completion
imap <C-X><C-K> <plug>(fzf-complete-word)
imap <C-X><C-F> <plug>(fzf-complete-path)
imap <C-X><C-J> <plug>(fzf-complete-file-ag)
imap <C-X><C-L> <plug>(fzf-complete-line)

function! CleanWord(word)
    return substitute(
        \    shellescape(a:word),
        \    '[\/,_]',
        \    ' ',
        \    'g'
        \ )
endfunction

" :Files - Start fzf searching files
command! -bar -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(
    \   '',
    \   {'options': '--query '. CleanWord(<q-args>) .' -i'}
    \ )

" :Rg  - Start fzf with hidden preview window that can be enabled with '?' key
" :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always  --glob "!build/*" --glob "!dist/*" --glob "!sandbox/*" '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:40%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

" Fuzzy search in all files names in current directory
noremap <leader>f :Files<CR>
" Fuzzy search for word under cursor in all files names in current directory
nnoremap <leader>ff :Files <C-R><C-W><CR>
" Fuzzy search for selected in all files names in current directory
vnoremap <leader>ff y :Files <C-R>"<CR>

" Fuzzy search in all files names in current buffer's directory
nnoremap <leader>p :Files %:h<CR>

" Fuzzy search in all open buffer lines
noremap <leader>l :Lines<CR>
" Fuzzy search for word under cursor in all open buffer lines
nnoremap <leader>ll :Lines <C-R><C-W><CR>
" Fuzzy search for selected  in all open buffer lines
vnoremap <leader>ll y :Lines <C-R>"<CR>

" Fuzzy search in all files in current directory
noremap <leader>r :Rg<CR>
" Fuzzy search for word under cursor in all files in current directory
nnoremap <leader>rr :Rg <C-R><C-W><CR>
" Fuzzy search for selected in all files in current directory
vnoremap <leader>rr y :Rg <C-R>"<CR>

" Fuzzy search in all files names in history
noremap <leader>h :History<CR>
" Fuzzy search in all open buffer names
noremap <leader>b :Buffers<CR>
" Fuzzy search in all window buffer names
noremap <leader>w :Windows<CR>
" Fuzzy search in all changed file names
noremap <leader>g :GFiles?<CR>
" Fuzzy search in all Help docs
noremap <leader>? :Helptags<CR>
" Fuzzy search in all commands
noremap <leader>c :Commands<CR>

" }}}

" -----------------------------------------------------------------------
" GitGutter {{{
" -----------------------------------------------------------------------
let g:gitgutter_sign_added='|'
let g:gitgutter_sign_modified='|'
let g:gitgutter_sign_removed_first_line='-'
let g:gitgutter_sign_modified_removed='|'
let g:gitgutter_diff_args='HEAD'

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual

" }}}

" -----------------------------------------------------------------------
" Incsearch {{{
" -----------------------------------------------------------------------
let g:incsearch#auto_nohlsearch = 1

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" }}}

" -----------------------------------------------------------------------
" Neosnippet {{{
" -----------------------------------------------------------------------
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#expand_word_boundary = 1

" Use tab to expand or jump for a snippet
imap <expr><TAB>
    \ pumvisible()
    \     ? "\<C-n>"
    \     : neosnippet#expandable_or_jumpable()
    \         ? "\<Plug>(neosnippet_expand_or_jump)"
    \         : "\<TAB>"
" Use tab to move to next expandable area in snippet
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" Alternate mapping for expand
imap <C-j>     <Plug>(neosnippet_expand_or_jump)

" }}}

" -----------------------------------------------------------------------
" Mappings {{{
" -----------------------------------------------------------------------
" autocompletion
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Edit vimrc and apply changes
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Change two vertically split windows to horizonally split
map <leader>vh <C-W>t<C-W>K

" Change two horizonally split windows to vertically split
map <leader>hv <C-W>t<C-W>H

" Trim trailing whitespace
map <leader>ws :%s/\s\+$//e<CR>

