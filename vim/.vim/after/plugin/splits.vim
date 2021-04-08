au VimResized * :wincmd =     " resize Split When the window is resized
set splitbelow splitright
nmap <C-W>z <Plug>(zoom-toggle)

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>tk <C-w>t<C-w>K
" Removes pipes | that act as seperators on splits
set fillchars+=vert:\
