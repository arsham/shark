" :tabnew        " opens a new buffer
" :0tabnew       " opens a new buffer in position 0
" :tabedit ~/.zshrc-local
" :tabfind ~/.zshrc-local
" :tab help                 " opens help in a tab
" :tab sp                   " opens split in a new tab
" :tabnext
" :tabmove +2
" :tabmove -2
" :tabs

nnoremap <Tab> gt                         " walk through tabs
nnoremap <S-Tab> gT                         " walk through tabs reversed
noremap <leader>z :tab split<CR>          " Open the current buffer in a new tab
nnoremap tn :tabnew<Space>

" Open every loaded buffer into a new tab
" nmap bt :tab sball<CR>
