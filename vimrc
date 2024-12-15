set nocompatible
filetype plugin on
syntax on

colorscheme habamax

set number relativenumber
set ruler

set laststatus=2
set showcmd

set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set autoindent

set display=truncate
set scrolloff=5
set nrformats-=octal

set incsearch

set foldlevelstart=99 foldmethod=syntax foldnestmax=5

" replace ex with fill-region keybind
map Q gq
sunmap Q

" reduce esc and O timeouts
set ttimeout ttimeoutlen=100

let plug_file = '~/.vim/autoload/plug.vim'
let plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(plug_file))
  silent execute '!curl -fLo '.plug_file.' --create-dirs '.plug_url
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'junegunn/vim-plug'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'prabirshrestha/vim-lsp'
Plug 'vimwiki/vimwiki'
Plug 'lervag/vimtex'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'

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

let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 
      \ 'syntax': 'markdown', 
      \ 'ext': 'md'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_ext2syntax = {}

let g:netrw_fastbrowse = 0

let uname = substitute(system('uname'), '\n', '', '')
if uname == 'Darwin'
  let g:vimtex_view_method = 'skim'
else " Linux
  let g:vimtex_view_method = 'zathura'
endif

nmap <leader>ff <cmd>Files<CR>
nmap <leader>fg <cmd>Rg<CR>
nmap <leader>fc <cmd>Commits<CR>
nmap <leader>fh <cmd>Helptags<CR>
