" :tabnew        " opens a new buffer
" :0tabnew       " opens a new buffer in position 0
" :tabedit ~/.zshrc-local
" :tabfind ~/.zshrc-local
" :tab help                 " opens help in a tab
" :tab sp                   " opens split in a new tab
" :tabmove +2
" :tabmove -2
" nmap bt :tab sball<CR>    " Open every loaded buffer into a new tab

" walk through tabs
nnoremap <Tab> gt
" walk through tabs reversed
nnoremap <S-Tab> gT
