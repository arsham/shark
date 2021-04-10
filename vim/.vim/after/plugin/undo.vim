if has('nvim')
    let s:undodir=expand("~/.cache/nvim/undodir")
    let s:backdir=expand("~/.cache/nvim/backdir")
else
    let s:undodir=expand("~/.cache/vim/undodir")
    let s:backdir=expand("~/.cache/vim/backdir")
endif

if !isdirectory(s:undodir)
    call mkdir(s:undodir, 'p')
endif
if !isdirectory(s:backdir)
    call mkdir(s:backdir, 'p')
endif

set undofile
"set noswapfile
"set nobackup

execute 'set undodir=' . s:undodir
execute 'set backupdir=' . s:backdir
execute 'set directory=' . s:backdir
