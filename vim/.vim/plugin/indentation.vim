set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
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

" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indentLine_concealcursor = 'inc'
" let g:indentLine_conceallevel = 1
"let g:indent_blankline_char = '>'
 let g:indent_blankline_show_trailing_blankline_indent = v:false
" set conceallevel=1
