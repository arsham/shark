" let the visual mode use the period. Try this to add : at the begining of all lines: 0i:<ESC>j0vG.
nnoremap g; g;zz
vnoremap . :norm.<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P
augroup TRAILING_SPACES
    autocmd!
    " Auto remove trailing spaces
    autocmd BufWritePre * silent! :%s/\s\+$//e
augroup END
set updatetime=100

" select a text, and this will replace it with the " contents.
vnoremap <leader>p "_dP

" emoji completion with <C-X> <C-U>
set completefunc=emoji#complete
" adds <> to % matchpairs
set matchpairs+=<:>
set complete=.,w,b,u,t,i
" can increment alphabetically too!
set nrformats=bin,hex,alpha

" make the regular expression less crazy
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

"nnoremap <leader>, norm m`A,``

" Moving lines with alt key.
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" mapping CTRL-a because inside tmux you can't!
nnoremap <M-a> <C-a>
