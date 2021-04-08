""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Important Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undolevels=10000
set ttyfast
set clipboard+=unnamed
set title
set number                      " line numbers
set relativenumber              " relative line numbers
set backspace=indent,eol,start  " allow backspace in insert mode
set history=10000                " :cmdline history
set showcmd                     " show commands at the bottom of the screen
set showmode                    " show current mode down the bottom
" set gcr=a:blinkon0              " disable cursor blink

" auto reload file if changed, need the following two
set autoread                    " reload files changed outside vim
au FileChangedShell * echo "Warning: File changed on disk"

set shortmess=filnxtToOFAI
set hidden
syntax on                       " syntax highlighting

let mapleader = " "
let g:indentLine_color_term = 239
let g:indentLine_fileTypeExclude = ['nerdtree']
augroup NERDTREE
    autocmd!
    autocmd FileType nerdtree setlocal conceallevel=2
augroup END

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

set viewoptions+=localoptions
set viewdir=$HOME/Projects/vim/views

" better diff view. This will make sure the inserted part is separated, rather
" than mangled in the previous blob.
set diffopt+=indent-heuristic




" coming from the old version that works.
"         let g:indentLine_color_term = 239
"         let g:indentLine_fileTypeExclude = ['nerdtree']
"         augroup NERDTREE
"             autocmd!
"             autocmd FileType nerdtree setlocal conceallevel=2
"         augroup END
"
"         noremap <Up> <Nop>
"         noremap <Down> <Nop>
"         noremap <Left> <Nop>
"         noremap <Right> <Nop>
"
"         inoremap <Up> <Nop>
"         inoremap <Down> <Nop>
"         inoremap <Left> <Nop>
"         inoremap <Right> <Nop>
"
"         set viewoptions+=localoptions
"         set viewdir=$HOME/Projects/vim/views
"
"         " better diff view. This will make sure the inserted part is separated, rather
"         " than mangled in the previous blob.
"         set diffopt+=indent-heuristic
