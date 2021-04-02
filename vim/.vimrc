" Use vim settings rather then vi.
set nocompatible                " must be first.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set number                      " line numbers
set backspace=indent,eol,start  " allow backspace in insert mode
set history=1000                " :cmdline history
set showcmd                     " show commands at the bottom of the screen
set showmode                    " show current mode down the bottom
" set gcr=a:blinkon0              " disable cursor blink

" auto reload file if changed, need the following two
set autoread                    " reload files changed outside vim
au FileChangedShell * echo "Warning: File changed on disk"

set hidden
syntax on                       " syntax highlighting

filetype plugin on
filetype indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" au BufNewFile,BufRead *.vundle set filetype=vim

filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


if has('nvim')
  call plug#begin('~/.vim/plugged/nvim')
else
  call plug#begin('~/.vim/plugged/vim')
endif

Plug 'adelarsq/vim-emoji-icon-theme'
set rtp+=~/.vim/init/                     " submodules
for f in split(glob('~/.vim/init/*.vim-plug'), '\n')
    exe 'source' f
endfor

call plug#end()
filetype plugin indent on                              " required

if has('nvim')
    set rtp+=~/.vim/plugins/                     " submodules
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Important Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undolevels=10000
set nu
set ttyfast
set clipboard+=unnamedplus
let mapleader = " "
nnoremap g; g;zz
set title

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim distro Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
runtime macros/matchit.vim

colorscheme onehalfdark
"nnoremap <silent> <C-p> :Files<CR>
