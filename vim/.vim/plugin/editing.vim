" <                 : Shift left
" >                 : Shift right
" =                 : Indent
" <C-r>3            : In INSERT mode it will paste the content of register 3
" <C-r>%            : In INSERT mode it will paste the name of the current file
" "0                : This is the yank register
" "/                : This is the current search pattern
" To capture the output of a command into a register:
"    :redir @a
"    :set guicursor?
"    :redir END


vnoremap . :norm.<CR>                    " let the visual mode use the period. Try this to add : at the begining of all lines: 0i:<ESC>j0vG.
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P
augroup TRAILING_SPACES
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e                     " Auto remove trailing spaces
augroup END
set updatetime=100

" move highlighed lines up and down.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" select a text, and this will replace it with the " contents.
vnoremap <leader>p "_dP

set completefunc=emoji#complete                       " emoji completion with <C-X> <C-U>
set matchpairs+=<:>                       " adds <> to % matchpairs
