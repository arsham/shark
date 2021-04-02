" ]s                : Go to the next misspelled word
" [s                : Go to the last misspelled word
" gu                : Make lowercase
" gU                : Make uppercase
" <C-x><C-t>        : Thesaurus
" <C-x><C-k>        : Dictionary
" <C-x><C-s>        : Spelling ----> need vim-spell-uk package installed
" <C-x><C-v>        : Vim commands in vimrc or in command mode

setlocal spelllang=en_gb
" set spell
nnoremap <leader>sp :set spell!<CR>
nnoremap <leader>spf 1z=
set thesaurus+=~/.config/thesaurus/moby.txt

augroup FILETYPES
  autocmd!
  autocmd BufNewFile,BufRead *.mkd,*.md,*.markdown setfiletype markdown
  autocmd BufNewFile,BufRead *.json setfiletype javascript
  autocmd BufNewFile,BufRead *.go setfiletype go
  autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype make,automake setlocal noexpandtab
  autocmd Filetype go setlocal noexpandtab
  autocmd Filetype markdown setlocal spell
  autocmd Filetype gitcommit setlocal spell
augroup END

