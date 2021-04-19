" resize Split When the window is resized
au VimResized * :wincmd =
set splitbelow splitright
nmap <C-W>z <Plug>(zoom-toggle)

" Removes pipes | that act as seperators on splits
set fillchars+=vert:│
