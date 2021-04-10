function! Increment() abort
  call search('\d\@<!\d\+\%#\d', 'b')
  call search('\d', 'c')
  norm! v
  call search('\d\+', 'ce')
  exe "norm!" "\<C-a>"
  return ''
endfun

" This is an example how the increment function could have been implemented.
" accepts a count, so that we can type 3<C-a> to add three to the next number.
" This is not something we could do with the :call version.
"nnoremap <silent> <C-a> @=Increment()<cr>
