" https://jovicailic.org/2017/04/vim-persistent-undo/
set undofile
if has('nvim')
    set undodir=~/tmp/.vim/undodir/nvim
else
    set undodir=~/tmp/.vim/undodir/vim
endif
