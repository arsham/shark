"enable ctrl-n and ctrl-p to scroll thru matches
set wildmenu
set wildmode=longest:full,full
set wildignorecase
"stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=*.pyc
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.zip,*.bg2,*.gz
set wildignore+=*.db
" show possible completions.
" set wildchar=<TAB>
" To invoke: CTRL-X CTRL-O
set omnifunc=syntaxcomplete#Complete
