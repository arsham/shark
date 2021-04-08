set noswapfile
set nobackup
if has('nvim')
    set backupdir=~/tmp/.vim/tmp/nvim
    set directory=~/tmp/.vim/tmp/nvim
else
    set backupdir=~/tmp/.vim/tmp/vim
    set directory=~/tmp/.vim/tmp/vim
endif
