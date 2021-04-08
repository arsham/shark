" A text object has two behaviors that need to be defined: visual mode, where
" it will select the appropriate text, and as a motion for an operator. So,
" you will need to use both a vmap and an omap to get the full text-object
" behavior.

" around line, without the newline
xnoremap <silent> al :<c-u>normal! $v0<cr>
onoremap <silent> al :<c-u>normal! $v0<cr>
