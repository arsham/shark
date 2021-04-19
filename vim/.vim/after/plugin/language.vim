" ]s                : Go to the next misspelled word
" [s                : Go to the last misspelled word
" <C-x><C-t>        : Thesaurus
" <C-x><C-k>        : Dictionary
" <C-x><C-s>        : Spelling ----> need vim-spell-uk package installed
" <C-x><C-v>        : Vim commands in vimrc or in command mode

set spelllang=en_gb
set nospell
"nnoremap <leader>sp :set spell!<CR>
"nnoremap <leader>spf 1z=
set thesaurus+=~/.config/thesaurus/moby.txt
" install words-insane package
set dictionary+=/usr/share/dict/words-insane

let s:spellfile=expand("~/.config/nvim/spell")
if !isdirectory(s:spellfile)
    call mkdir(s:spellfile, 'p')
endif
execute 'set spellfile=' . s:spellfile . "/en.utf-8.add"

augroup FILETYPES
  autocmd!
  " autocmd BufNewFile,BufRead *.mkd,*.md,*.markdown setfiletype markdown
  " autocmd BufNewFile,BufRead *.json setfiletype javascript
  " autocmd BufNewFile,BufRead *.go setfiletype go
  autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype make,automake setlocal noexpandtab
  autocmd Filetype markdown setlocal spell
  autocmd Filetype gitcommit setlocal spell
augroup END

" auto correct spelling and jump back.
function! FixLastSpellingError()
    let l:currentspell=&spell
    setlocal spell
    normal! [s1z=``
    let &l:spell=l:currentspell
endfunction
nnoremap <leader>sp :call FixLastSpellingError()<cr>
