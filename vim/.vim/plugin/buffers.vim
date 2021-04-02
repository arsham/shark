" nmap bu :Buffers<CR>

" Delete buffers
" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
" function! s:list_buffers()
"   redir => list
"   silent ls
"   redir END
"   return split(list, "\n")
" endfunction
"
" nmap bd :bd<CR>
" nmap BD :Bdelete hidden<CR>
" nmap <leader>w :w<CR>
" nmap <leader>q :q<CR>
" nmap <leader>Q :qa!<CR>
" nmap <leader>d :w !diff % -<CR>
" nmap mk :mks!<CR>

 " Make Sure that Vim returns to the same line when we reopen a file"
augroup line_return
    au!
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \ execute 'normal! g`"zvzz' |
                \ endif
augroup END

let g:LargeFile = 512                  " anything larger than 512MB is going to be ignores by syntax highlighting, events, etc.
