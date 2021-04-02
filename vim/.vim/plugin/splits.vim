" noremap <leader>v :vsp<CR><C-w><C-w> " quick vertical split

au VimResized * :wincmd =     " resize Split When the window is resized
set splitbelow splitright

" nnoremap <down> <C-W><C-J>
" nnoremap <left> <C-W><C-H>
" nnoremap <right> <C-W><C-L>
" nnoremap <up> <C-W><C-K>

nnoremap <silent> <C-Left> :vertical resize -3<CR>
nnoremap <silent> <C-Right> :vertical resize +3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>
nmap <C-W>z <Plug>(zoom-toggle)

" nnoremap <leader>tt :tab term<CR>

map <Leader>th <C-w>t<C-w>H              " Change 2 split windows from vert to horiz or horiz to vert
map <Leader>tk <C-w>t<C-w>K              " Change 2 split windows from vert to horiz or horiz to vert
set fillchars+=vert:\                    " Removes pipes | that act as seperators on splits



" map <Leader>j <C-W><C-J>       " ctrl-j    Jump to buttom pane
" map <Leader>k <C-W><C-K>       " ctrl-k    Jump to top pane
" map <Leader>l <C-W><C-L>       " ctrl-l    Jump to right pane
" map <Leader>h <C-W><C-H>       " ctrl-h    Jump to left pane

" failed, but interesting
" map <C-J> <C-W><C-J>       " ctrl-j    Jump to buttom pane
" map <C-K> <C-W><C-K>       " ctrl-k    Jump to top pane
" map <C-L> <C-W><C-L>       " ctrl-l    Jump to right pane
" map <C-H> <C-W><C-H>       " ctrl-h    Jump to left pane
" nnoremap <esc>[1;5B <C-W><C-J>       " ctrl-down  Jump to buttom pane
" nnoremap <esc>[1;5A <C-W><C-K>       " ctrl-up    Jump to top pane
" nnoremap <esc>[1;5C <C-W><C-L>       " ctrl-right Jump to right pane
" nnoremap <esc>[1;5D <C-W><C-H>       " ctrl-left  Jump to left pane

" what are these?
" nnoremap <leader>h :wincmd h<CR>
" nnoremap <leader>j :wincmd j<CR>
" nnoremap <leader>k :wincmd k<CR>
" nnoremap <leader>l :wincmd l<CR>
