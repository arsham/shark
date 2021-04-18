set undolevels=10000
set ttyfast
set clipboard+=unnamed
set title
set number
set relativenumber
" allow backspace in insert mode
set backspace=indent,eol,start
set history=10000
" show commands at the bottom of the screen
set showcmd
set showmode

" auto reload file if changed, need the following two
" reload files changed outside vim
set autoread
au FileChangedShell * echo "Warning: File changed on disk"
" au FocusGained,BufEnter * : checktime

set shortmess=afilnxtToOFAI
set hidden
syntax on

let mapleader = " "
let g:indentLine_color_term = 239
let g:indentLine_fileTypeExclude = ['nerdtree']

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

set viewoptions+=localoptions
set viewdir=$HOME/.cache/vim/views

" better diff view. This will make sure the inserted part is separated, rather
" than mangled in the previous blob.
set diffopt+=indent-heuristic

" Disable Ex mode
nmap Q <Nop>

set suffixesadd+=.go,.py
