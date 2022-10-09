set hidden

" need this in favor of fzf.vim
set autochdir

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300


"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" coc settings
" Personally, i will remove coc, and have plan to move to nvim-lsp
"
"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
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

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

" 1) read opened files again if changes are occurred outside nvim
" 2) write a modified buffer on each :next, ...
set autoread
set autowrite

" use incremental search
set incsearch

" clipboard sharing
set clipboard+=unnamedplus

" tab and indent setting
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set cindent

" turn on line number
set number
set title

" syntax highlighting
syntax enable
syntax on

" disable mouse
set mouse-=a

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=auto

"-------------------------------------------------------------------------------
" Filename completion
"
"   wildmenu : command-line completion operates in an enhanced mode
" wildignore : A file that matches with one of these
"              patterns is ignored when completing file or directory names.
"-------------------------------------------------------------------------------
"
set wildmenu
set wildignore=*.bak,*.o,*.e,*~


" configuration for yaml
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2


" configuration for html/css
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

" configuration for c cpp
autocmd FileType c,cpp call vista#sidebar#Toggle()

" configuration for python
autocmd FileType python call vista#sidebar#Toggle()


" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Solarized
"" Plug 'altercation/vim-colors-solarized'
" Solarized 8
Plug 'lifepillar/vim-solarized8'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'

" vim-airline
" Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"let g:airline_theme='solarized'

Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>


" vim-cpp-modern (Modern C++ syntax highlighting)
Plug 'bfrg/vim-cpp-modern'


" vim-lsp (Language Server Protocol)
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'



Plug 'ntpeters/vim-better-whitespace',  { 'commit' : '8cf4b2175dd61416c2fe7d3234324a6c59d678de' }
Plug 'junegunn/fzf',                    { 'tag': '0.18.0', 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim',                { 'commit': 'b31512e2a2d062ee4b6eb38864594c83f1ad2c2f' }


" Initialize plugin system
call plug#end()


" lsp handler
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
    inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'
    inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : '<cr>'
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gr <plug>(lsp-rename)
    nmap <buffer> <leader>k <plug>(lsp-hover)
    nmap <buffer> <leader>p <plug>(lsp-code-action)
endfunction


" clangd
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" theme
set termguicolors
set background=dark
autocmd vimenter * ++nested colorscheme solarized8_flat
" let g:solarized_termcolors=256
let g:solarized_termtrans=1

