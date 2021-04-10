" let the visual mode use the period. Try this to add : at the begining of all lines: 0i:<ESC>j0vG.
nnoremap g; g;zz
vnoremap . :norm.<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>P "+P
augroup TRAILING_SPACES
    autocmd!
    " Auto remove trailing spaces
    autocmd BufWritePre * :%s/\s\+$//e
augroup END
set updatetime=100

" move highlighed lines up and down.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move line up and down
nmap <M-j> ddp
nmap <M-k> ddkP

" select a text, and this will replace it with the " contents.
vnoremap <leader>p "_dP

" emoji completion with <C-X> <C-U>
set completefunc=emoji#complete
" adds <> to % matchpairs
set matchpairs+=<:>
set complete=.,w,b,u,t,i
" can increment alphabetically too!
set nrformats=bin,octal,hex,alpha
