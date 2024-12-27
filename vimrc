vim9script

set nocompatible
filetype plugin on
syntax on

set number relativenumber
set ruler
set signcolumn=yes

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

colorscheme habamax
highlight Normal ctermbg=NONE guibg=NONE
highlight Comment cterm=italic gui=italic

# replace ex with fill-region keybind
map Q gq
sunmap Q

# loclist is used by ale for diagnostics
nmap [g <cmd>lprevious<CR>
nmap ]g <cmd>lnext<CR>
nmap <leader>g <cmd>lopen<CR>

# qflist is used by ale for references
nmap [q <cmd>cprevious<CR>
nmap ]q <cmd>cnext<CR>
nmap <leader>q <cmd>copen<CR>

# reduce esc and O timeouts
set ttimeout ttimeoutlen=100

var plug_file = '~/.vim/autoload/plug.vim'
var plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(plug_file))
  silent execute '!curl -fLo '.plug_file.' --create-dirs '.plug_url
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

packadd! comment

call plug#begin()

Plug 'https://github.com/junegunn/vim-plug'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/Konfekt/FastFold'
Plug 'https://github.com/ervandew/supertab'
Plug 'https://github.com/dense-analysis/ale'

call plug#end()

nmap zuz <plug>(FastFoldUpdate)
g:fastfold_fold_command_suffixes = []
g:fastfold_minlines = 0
g:fastfold_foldmethods = ['syntax', 'expr']

g:SuperTabDefaultCompletionType = 'context'
g:SuperTabContextDefaultCompletionType = '<C-x><C-o>'

g:ale_floating_preview = 1
g:ale_completion_autoimport = 0

# linters = lsp servers
g:ale_linters = {
  'c': ['clangd'],
  'cpp': ['clangd'],
  'python': ['pylsp'],
  'rust': ['rust_analyzer'],
}

# fixers = formatters
g:ale_fixers = {
  '*': ['remove_trailing_lines', 'trim_whitespace'],
  'c': ['clang-format'],
  'cpp': ['clang-format'],
  'python': ['black'],
  'rust': ['rustfmt'],
}

def ALEBufferSettings()
  setlocal omnifunc=ale#completion#OmniFunc
  nmap <buffer> K <cmd>ALEHover<CR>
  nmap <buffer> gr <cmd>ALEFindReferences<CR>
  nmap <buffer> <leader>fx <cmd>ALEFix<CR>
  nmap <buffer> gd <cmd>ALEGoToDefinition<CR>
  nmap <buffer> gT <cmd>ALEGoToTypeDefinition<CR>
  nmap <buffer> gI <cmd>ALEGoToImplementation<CR>
  nmap <buffer> <leader>rn <cmd>ALERename<CR>
  nmap <buffer> <leader>ca <cmd>ALECodeAction<CR>
enddef
autocmd User ALELSPStarted call ALEBufferSettings()
