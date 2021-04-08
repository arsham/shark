set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
" SEEMS TO CAUSE ISSUES FOR NVIM
""""""""""""""""""""""""""""nnoremap p p=`]<C-o>
""""""""""""""""""""""""""""""""nnoremap P P=`]<C-o>

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" Display tabs and trailing spaces visually
" set listchars=tab:>~,nbsp:_,trail:.
" set listchars=tab:>-,trail:·,eol:$

""""""""let g:indentLine_color_term = 239
""""""""let g:indentLine_fileTypeExclude = ['nerdtree']
""""""""augroup NERDTREE
""""""""    autocmd!
""""""""    autocmd FileType nerdtree setlocal conceallevel=2
""""""""augroup END
""""""""
" hacks for vim-go
set list                                    " otherwise the indentations are not visible
" set list lcs=tab:\┆\ " KEEP THIS SPACE      " needs to be here otherwise vim-go stops the indentLine
set list listchars=tab:\ \ ,trail:·

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 1
set conceallevel=1
