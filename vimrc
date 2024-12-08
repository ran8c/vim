filetype plugin on
syntax on

colorscheme habamax

set number relativenumber
set laststatus=2

set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set autoindent

" replace ex with fill-region keybind
map Q gq
sunmap Q

" requires vim >=v9.1.0375 (~may 2024)
packadd! comment

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

call plug#end()

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
