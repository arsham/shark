" find out what these are
" set sessionoptions-=blank
" set sessionoptions-=buffers
" set sessionoptions-=winsize

"" https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/
" highlight Comment cterm=italic

" Make it easier to use marks
" nmap ' `

" nmap <leader>E :Error<CR><C-w>j


" Toggle line numbers
" nmap <leader>N :set number!<CR>

"
" map <Leader>n <esc>:tabprevious<CR>
" map <Leader>m <esc>:tabnext<CR>
"
" " Map sort function to s
" vnoremap <Leader>s :sort<CR>
"
" vnoremap < <gv "Better Indention
" vnoremap > >gv "Better Indention
"
" no <C-j> ddp # Move line down
" no <C-k> ddkP # Move line up


" Quickly get rid of highlighting
" noremap <leader>h :noh<CR>


" Make j and k work normally for soft wrapped lines
" noremap <buffer> j gj
" noremap <buffer> k gk


" Fix Vim's ridiculous line wrapping model
" set ww=<,>,[,],h,l

" noremap <C-h> :tabp<CR>
" noremap - :tabm -1<CR>
" noremap <C-l> :tabn<CR>
" noremap = :tabm +1<CR>
" noremap <C-j> :tabc<CR>
" noremap <C-k> :tabe <Bar> Startify<CR>

" nmap <leader>t :FloatermNew<CR>


" " Enable or disable auto width-formatting.
" noremap <leader>f :call UnsetGutter()<CR>
" noremap <leader>F :call SetGutter()<CR>
"
" " Disable Ex mode
" nmap Q <Nop>
"
" function! SetGutter()
"   set tw=79
"   exec 'set colorcolumn=' . join(range(80, 500), ',')
" endfunction
"
" function! UnsetGutter()
"   set tw=0
"   set colorcolumn=0
" endfunction



" Map <leader> + 1-9 to jump to respective tab
" let i = 1
" while i < 10
"   execute ":nmap <leader>" . i . " :tabn " . i . "<CR>"
"   let i += 1
" endwhile


" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => splitjoin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gS and gJ


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Multi cursor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:multi_cursor_start_word_key      = '<C-d>'
" let g:multi_cursor_select_all_word_key = '<A-n>'
" let g:multi_cursor_start_key           = 'g<C-n>'
" let g:multi_cursor_select_all_key      = 'g<A-n>'
" let g:multi_cursor_next_key            = '<C-n>'
" let g:multi_cursor_prev_key            = '<C-p>'
" let g:multi_cursor_skip_key            = '<C-x>'
" let g:multi_cursor_quit_key            = '<Esc>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => windowswap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:windowswap_map_keys = 0 "prevent default bindings
" nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
" nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
" nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>


"au BufNewFile,BufRead *.vundle set filetype=vim
