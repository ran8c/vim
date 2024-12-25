vim9script

set nocompatible
filetype plugin on
syntax on

set number relativenumber
set ruler

set laststatus=2
set showcmd

set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set autoindent

set completeopt=menu,menuone
set shortmess+=c

set display=truncate
set scrolloff=5
set nrformats-=octal

set incsearch

set foldlevelstart=99 foldmethod=syntax foldnestmax=5

# replace ex with fill-region keybind
map Q gq
sunmap Q

# reduce esc and O timeouts
set ttimeout ttimeoutlen=100

var plug_file = '~/.vim/autoload/plug.vim'
var plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(plug_file))
  silent execute '!curl -fLo '.plug_file.' --create-dirs '.plug_url
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'https://github.com/junegunn/vim-plug'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/prabirshrestha/vim-lsp'
Plug 'https://github.com/Konfekt/FastFold'
Plug 'https://github.com/vimwiki/vimwiki'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://git.sr.ht/~ackyshake/VimCompletesMe.vim'
Plug 'https://github.com/rose-pine/vim'

call plug#end()

if executable('pylsp')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \})
endif

if executable('clangd')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'allowlist': ['c', 'cpp'],
        \})
endif

if executable('rust-analyzer')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rust-analyzer']},
        \ 'allowlist': ['rust'],
        \})
endif

let g:lsp_document_highlight_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  setlocal foldmethod=expr
        \ foldexpr=lsp#ui#vim#folding#foldexpr()
        \ foldtext=lsp#ui#vim#folding#foldtext()
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gD <plug>(lsp-declaration)
  nmap <buffer> gs <plug>(lsp-document-symbol)
  nmap <buffer> gS <plug>(lsp-workspace-symbol)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>fm <plug>(lsp-document-format)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> <leader>gg <plug>(lsp-document-diagnostics)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

nmap zuz <plug>(FastFoldUpdate)
g:fastfold_fold_command_suffixes = []
g:fastfold_minlines = 0
g:fastfold_foldmethods = ['syntax', 'expr']

g:vimwiki_list = [{
    'path': '~/Documents/Wiki', 
    'syntax': 'markdown', 
    'ext': 'md'}]
g:vimwiki_ext2syntax = {}

g:disable_bg = 1
colorscheme rosepine
