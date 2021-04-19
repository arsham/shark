set autoindent
set smartindent
set smarttab
" set shiftwidth=2
" set softtabstop=2
" set tabstop=2
set expandtab
"Don't wrap lines
set nowrap
"Wrap lines at convenient points
set linebreak

" hacks for vim-go
" otherwise the indentations are not visible
set list
" set list lcs=tab:\┆\ " KEEP THIS SPACE      " needs to be here otherwise vim-go stops the indentLine
set list listchars=tab:\ \ ,trail:·
